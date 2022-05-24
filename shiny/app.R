library(shiny)
library(shinyvalidate)
library(shinycssloaders)
library(reactlog)
library(config)
library(thematic)
library(ggplot2)
library(dplyr, warn.conflicts = FALSE)
library(stringr)
library(lubridate)
library(tibble)
library(fs)
library(readr)

options(shiny.sanitize.errors = TRUE)

species_images <- tribble(
  ~species, ~id, ~author,
  "Chinstrap", "ZZyK8GjFJ4Q", "rocinante_11",
  "Gentoo", "LAQ2QfYTpTY", "tamwarnerminton",
  "Adelie", "9k9tNQTwMEA", "dylanshaw"
)

# Dialog box
modal_confirm <- modalDialog(
  "Clear measurements functionality required",
  title = str_glue("Clear measurements"),
  footer = tagList(
    actionButton("cancel", "Cancel"),
    actionButton("ok", "Clear" , class = "btn-sm btn-primary")
  ))

# reactlog
### https://rstudio.github.io/reactlog/
### Ctrl-F3 or shiny::reactlogShow()
reactlog_enable()

# read config file
### https://github.com/rstudio/config
Sys.setenv(R_CONFIG_ACTIVE = "testing")
config <- config::get()

# Upload data ------------------------------------------------------------------
ui_page_1 <- sidebarLayout(
  sidebarPanel(width = 3,
               fileInput("penguins_upload", "Upload penguin data", accept = ".csv")
  ),
  mainPanel()
)

# Immediate and Delayed reactivity inputs --------------------------------------
ui_page_2 <- sidebarLayout(
  sidebarPanel(width = 3,

               selectInput("species_selected", "Select a penguin species", choices = NULL),
               numericInput("species_year", "Select year", value = NULL, min = 0, max = 0),

               htmlOutput("species_image_source"),
               imageOutput("species_image", height = "350px"),

               actionButton("display_button", "Display species measurements",
                            class = "btn-sm btn-primary")
  ),
  mainPanel(
    fluidRow(
      column(5,
             withSpinner(plotOutput("species_plot",
                                    brush = brushOpts(id = "plot_brush",
                                                      fill = "gold", stroke = "black",
                                                      resetOnNew = TRUE),
                                    height = "350px"))
      ),
      column(7,
             tableOutput("species_plot_selected")
      )
    ),
    fluidRow(
      column(12,
             dataTableOutput("species_table")
      )
    )
  )
)

# UI layout
ui <- function(request) {
  fluidPage(
    h1(""),
    tabsetPanel(
      id = "wizard",
      type = "hidden",
      # Upload page
      tabPanel("page_1",
               ui_page_1
      ),
      # Display page
      tabPanel("page_2",
               ui_page_2
      )
    ),
    uiOutput("download"),
    uiOutput("clear")
  )
}

server <- function(input, output, session) {

  # update UI page ---------------------------------------------------------------
  switch_page <- function(i) {
    updateTabsetPanel(inputId = "wizard", selected = paste0("page_", i))
  }

  observeEvent(input$penguins_upload, switch_page(2))

  # Bookmark ---------------------------------------------------------------------
  ### https://shiny.rstudio.com/articles/bookmarking-state.html
  ### https://shiny.rstudio.com/articles/advanced-bookmarking.html
  observe({
    reactiveValuesToList(input)
    session$doBookmark()
  })
  onBookmarked(updateQueryString)

  # Upload data ------------------------------------------------------------------

  ## Reactive expressions
  penguins_data <- reactive({

    req(input$penguins_upload)
    read_csv(input$penguins_upload$datapath,
             col_types = cols(body_mass_g = col_integer(),
                              flipper_length_mm = col_integer(),
                              year = col_integer()))
  })

  # Immediate reactivity -------------------------------------------------------

  ## initiate validation
  check_input <- InputValidator$new()

  ## Validation rules
  check_input$add_rule("species_selected", sv_optional())
  check_input$add_rule("species_year", sv_optional())
  check_input$add_rule("species_year", sv_between(
    left = 2007,
    right = 2009,
    inclusive = c(TRUE, TRUE),
    message_fmt = "measurements not available"))

  ## turn on validation
  check_input$enable()

  ## Notification
  notify <- function(msg, id = NULL, duration = NULL) {
    showNotification(msg, id = id, duration = duration,
                     closeButton = FALSE, type = "message")
  }

  ## Update input boxes
  ### species_selected choices
  species_list <- reactive({
    penguins_data()  %>%
      distinct(species) %>%
      arrange(species) %>%
      pull()
  })

  observeEvent(species_list(), {
    updateSelectInput(inputId = "species_selected", choices = species_list())
  })

  ### species_year choices
  year_list <- reactive({
    penguins_data() %>%
      distinct(year) %>%
      arrange(year) %>%
      pull()
  })

  observeEvent(year_list(), {
    updateNumericInput(inputId = "species_year",
                       value = min(year_list()),
                       min = min(year_list() - 1), max = max(year_list() + 1))
  })

  ## update action button label
  button_label <- reactive({
    str_glue("{input$species_year} {input$species_selected}")
  })

  observeEvent(button_label(), {
    updateActionButton(inputId = "display_button", label = str_glue("Display {button_label()} measurements"))
  })

  species_data_plot <- reactive({

    req(check_input$is_valid())

    if(input$species_selected == "Gentoo" && input$species_year == 2008) {
      validate("Gentoo measurements for 2008 are not available")
    }

    penguins_data() %>%
      filter(species == input$species_selected, year == input$species_year) %>%
      select(-starts_with("bill"))

  })

  ## side effects reactivity: Notifications
  observeEvent(input$species_selected, {

    req(penguins_data())

    id <- notify(str_glue("Getting {input$species_selected} penguin data"))
    on.exit(removeNotification(id), add = TRUE)
    Sys.sleep(0.5)

    notify(str_glue("Getting {input$species_selected} penguin image"), id = id)
    Sys.sleep(0.5)

    notify(str_glue("Extracting measurements for {input$species_year}"), id = id)
    Sys.sleep(0.5)

    notify(str_glue("Creating {input$species_selected} penguin plot"), id = id)
    Sys.sleep(0.5)
  })

  ## Outputs
  output$species_image_source <- renderUI({

    info <- species_images %>%
      filter(species == input$species_selected)
    HTML(str_glue("<p>
                              <a href='https://unsplash.com/photos/{info$id}'>original</a> by
                              <a href='https://unsplash.com/@{info$author}'>{info$author}</a>
                              </p>"))
  })

  output$species_image <- renderImage({

    list(
      src = path("images", str_glue("{input$species_selected}.jpg")),
      width = 211,
      height = 317
    )
  }, deleteFile = FALSE)

  output$species_text <- renderText({

    req(check_input$is_valid())

    input$species_selected
  })

  output$species_plot <- renderPlot({
    ggplot(data = penguins_data(), aes(x = flipper_length_mm, y = body_mass_g)) +
      geom_point(size = 2, colour = "grey", alpha = 0.6) +
      geom_point(data = species_data_plot(),
                 aes(x = flipper_length_mm, y = body_mass_g),
                 size = 2, colour = "steelblue") +
      ggplot2::theme_bw()
  }, res = 96)

  output$species_plot_selected <- renderTable({
    req(input$plot_brush)
    brushedPoints(species_data_plot(), input$plot_brush)
  })

  # Delayed reactivity ---------------------------------------------------------

  ## eventReactive
  species_data_table <- eventReactive(input$display_button, {

    species_data_plot()
  })

  ### side effect reactivity: Dialog Box
  observeEvent(input$display_button, {

    output$species_table <- renderDataTable(
      species_data_table(), options= list(pageLength = 5)
    )
  })

  # Download data ----------------------------------------------------------------
  ## Dynamically add download sidebarPanel to UI
  observeEvent(input$display_button, {
    output$download <- renderUI({
      label_text <- isolate(str_glue("Download {button_label()} measurements"))
      sidebarLayout(
        sidebarPanel(width = 3,
                     downloadButton("download_button", label_text,
                                    class = "btn-sm btn-primary")
        ),
        mainPanel()
      )
    })
  })

  output$download_button <- downloadHandler(

    filename = function() {
      str_glue("{input$species_selected}_{input$species_year}.csv")
    },
    content = function(file){
      write_csv(species_data_plot(), file)
    }
  )

  ## Clear app -----------------------------------------------------------------
  observeEvent(input$display_button, {
    output$clear <- renderUI({
        label_text <- isolate(str_glue("Clear {button_label()} measurements"))
        sidebarLayout(
          sidebarPanel(width = 3,
                       actionButton("clear_button", label_text,
                                    class = "btn-sm btn-primary")
          ),
          mainPanel()
        )
      })

    ### side effect reactivity: Dialog Box
    observeEvent(input$clear_button, {
      showModal(modal_confirm)
    })

    observeEvent(input$ok, {
      removeModal()
    })

    observeEvent(input$cancel, {
      removeModal()
    })
  })

  # Timed reactivity -------------------------------------------------------------
  ### https://mastering-shiny.org/reactivity-objects.html
  secs <- reactiveVal(0)

  ## Triggered reaction
  ### https://shiny.rstudio.com/reference/shiny/0.14/invalidateLater.html
  ### https://shiny.rstudio.com/reference/shiny/0.14/reactiveTimer.html
  observe({
    secs(isolate(secs()) + config$timer_seconds)
    invalidateLater(config$timer_seconds * 1000) # milliseconds
  })

  observeEvent(secs(),
               notify(str_glue("Running for {secs()} seconds ..."), duration = 1))
}

## Bookmark: url or server
shinyApp(ui, server, enableBookmarking = "url")
