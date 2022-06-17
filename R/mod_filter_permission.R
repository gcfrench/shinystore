#' @title
#' Shiny module filter permission UI Function
#'
#' @description
#' Shiny module to filter dataset using selectInput and numericInput controls and
#' manage permissions to display data.
#'
#' @details
#' * [Dynamic selectInput](https://shiny.rstudio.com/articles/selectize.html#server-side-selectize)
#' * [Using sliders](https://shiny.rstudio.com/articles/sliders.html)
#'
#' @param id Internal parameters for {shiny}.
#'
#' @importFrom shiny NS tagList
#' @export
mod_filter_permission_ui <- function(id, dataset_name){
  ns <- NS(id)
  tagList(
    selectInput(ns("species_selected"), glue::glue_safe("Select a {dataset_name} species"), choices = NULL),
    numericInput(ns("species_year"), "Select year", value = NULL, min = 0, max = 0),
    uiOutput(ns("permission_display")),
    uiOutput(ns("permission_table"))
  )
}

#' @title
#' Shiny module filter permission server function
#'
#' @description
#' This shiny module uses the dataset returned from the upload module to
#'
#' * populate species and year drop down options in the input controls.
#' * filter the dataset by the selected species and year in the drop down option.
#' * validate the input control options and filtered dataset.
#' * dynamically add buttons seeking permission to display plot and table of filtered data.
#' (default, permission_required = TRUE), else skips this permission step (permission_required = FALSE),
#' * send notification of returned reactive values.
#'
#' @details
#' * [freezeReactiveValue](https://shiny.rstudio.com/reference/shiny/0.14/freezeReactiveValue.html) prevents flicker in dynamic controls
#' * [shinyValidate](https://rstudio.github.io/shinyvalidate)
#' * [shinyFeedback](https://github.com/merlinoa/shinyFeedback)
#' * [shinyAlert](https://github.com/daattali/shinyalert)
#'
#' @inheritParams mod_upload_server
#'
#' @return species_list(), year_list and filter_data() reactive value containing uploaded data from csv file.
#'
#' @export
mod_filter_permission_server <- function(id, mod_values, permission_required = TRUE){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    ## Update input boxes ------------------------------------------------------
    ### species_selected choices
    species_list <- reactive({
      req(mod_values$upload_data)
      mod_values$upload_data %>%
        dplyr::distinct(species) %>%
        dplyr::arrange(species) %>%
        dplyr::pull()
    })

    observeEvent(species_list(), {
      updateSelectInput(inputId = "species_selected", choices = species_list())
    })

    ### species_year choices
    year_list <- reactive({
      req(mod_values$upload_data)
      mod_values$upload_data %>%
        dplyr::distinct(year) %>%
        dplyr::arrange(year) %>%
        dplyr::pull()
    })

    observeEvent(year_list(), {
      updateNumericInput(inputId = "species_year",
                         value = min(year_list()),
                         min = min(year_list() - 1), max = max(year_list() + 1))
    })

    # Validate input values ---------------------------------------------------
    # initiate validation
    check_input <- shinyvalidate::InputValidator$new()

    ### Validation rules
    check_input$add_rule("species_selected", shinyvalidate::sv_required())
    check_input$add_rule("species_year", shinyvalidate::sv_required())
    check_input$add_rule("species_year", shinyvalidate::sv_between(
      left = 2007,
      right = 2009,
      inclusive = c(TRUE, TRUE),
      message_fmt = "measurements not available"))

    ### turn on validation
    check_input$enable()

    ## Update filter_data ------------------------------------------------------
    filter_data <- reactive({
      req(check_input$is_valid())
      req(mod_values$upload_data)
      mod_values$upload_data %>%
        dplyr::filter(species == input$species_selected, year == input$species_year) %>%
        dplyr::select(-starts_with("bill"))
    })

    ## Manage permissions to data ----------------------------------------------
    ### Reset permissions on updating filtered data
    observeEvent(filter_data(), {
      if(permission_required) {
        mod_values$display_plot <- FALSE
        mod_values$display_table <- FALSE
      } else {
        mod_values$display_plot <- TRUE
        mod_values$display_table <- TRUE
      }
    })

    ## Display permission buttons
    if(permission_required) {
      output$permission_display <- renderUI ({
        req(filter_data())
        tagList(
          actionButton(ns("display_plot"), "Display plot",
                       icon = icon("chart-bar"),
                       class = "btn-sm btn-success"),
          actionButton(ns("display_table"), "Display table",
                       icon = icon("table"),
                       class = "btn-sm btn-success")
        )
      })
    }

    ### Add check icon to permission button clicking
    observeEvent(input$display_plot, {
      updateActionButton(inputId = "display_plot",
                         icon = icon("check"))
    })

    observeEvent(input$display_table, {
      updateActionButton(inputId = "display_table",
                         icon = icon("check"))
    })

    # Return reactive values stored in mod_values reactiveValues -------------- HERE
    observeEvent(input$species_selected, {
        mod_values$species_selected <- input$species_selected
    })

    observeEvent(input$species_year, {
      mod_values$species_year <- input$species_year
    })

    observeEvent(filter_data(), {
      if(nrow(req(filter_data() != 0))) {
        mod_values$filter_data <- filter_data()
      }
    })

    observeEvent(input$display_plot, {
      mod_values$display_plot <- TRUE

      id <- notify(glue::glue("plot permission {isolate(mod_values$display_plot)}"))
      on.exit(shiny::removeNotification(id), add = TRUE)
      Sys.sleep(0.5)

    })

    observeEvent(input$display_table, {
      mod_values$display_table <- TRUE

      id <- notify(glue::glue("table permission {isolate(mod_values$display_table)}"))
      on.exit(shiny::removeNotification(id), add = TRUE)
      Sys.sleep(0.5)

    })

    # Notify module returning reactive values
    observeEvent(mod_values$filter_data, {
        id <- notify(glue::glue("filter module returned {nrow(isolate(mod_values$filter_data))} rows"))
        on.exit(shiny::removeNotification(id), add = TRUE)
        Sys.sleep(0.5)

        notify(glue::glue("filter module returned {isolate(mod_values$species_selected)}"), id = id)
        Sys.sleep(0.5)

        notify(glue::glue("filter module returned {isolate(mod_values$species_year)}"), id = id)
        Sys.sleep(0.5)

        notify(glue::glue("plot permission {isolate(mod_values$display_plot)}"), id = id)
        Sys.sleep(0.5)

        notify(glue::glue("table permission {isolate(mod_values$display_table)}"), id = id)
        Sys.sleep(0.5)
    })
  })
}

## To be copied in the UI
# mod_filter_ui("filter_1")

## To be copied in the server
# mod_filter_server("filter_1")
