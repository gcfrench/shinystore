#' @title
#' The application server-side
#'
#' @details
#' * [bookmark state](https://shiny.rstudio.com/articles/bookmarking-state.html)
#' * [advanced bookmarking](https://shiny.rstudio.com/articles/advanced-bookmarking.html)
#' * [config package](https://github.com/rstudio/config)
#' * [Scheduled invalidation](https://shiny.rstudio.com/reference/shiny/0.14/invalidateLater.html)
#' * [Reactive timer](https://shiny.rstudio.com/reference/shiny/0.14/reactiveTimer.html)
#'
#' @param input,output,session Internal parameters for {shiny}.
#' @param mod_values a 'reactiveValues() list storing returned values from server modules,
#' containing the following elements
#'
#' * 'upload_data' uploaded csv file as data frame.
#' * 'species_selected' species select in selectInput input control.
#' * 'species_year' year selected in numericInput input control.
#' * 'filter_data' uploaded csv file filtered by species and year list.
#' * 'display_plot' boolean permission to display plot.
#' * 'display_table' boolean permission to display table.
#'
#' @import shiny
#'
#' @export
app_server <- function(input, output, session) {

  # bookmark -------------------------------------------------------------------
  ## set enableBookmarking in shinyApp(ui, server, enableBookmarking = "url")
  observe({
    reactiveValuesToList(input)
    session$doBookmark()
  })
  onBookmarked(updateQueryString)

  # UI modules -----------------------------------------------------------------
  output$tab1UI <- renderUI({
    fluidPage(
      fluidRow(
        shinydashboard::box(width = 6, collapsible = TRUE, title = "Upload",
                            solidHeader = TRUE, status = "primary",
                            mod_upload_ui("upload_1", dataset_name = "penguin")
        )
      ),
      fluidRow(
        shinydashboard::box(width = 6, collapsible = TRUE, title = "Filter",
                            solidHeader = TRUE, status = "primary",
                            mod_filter_permission_ui("filter_1", dataset_name = "penguin")

        )
      )
    )
  })

  output$tab2UI <- renderUI({
    fluidPage(
      fluidRow(
        shinydashboard::box(width = 5, height = 750, collapsible = TRUE, title = "Image",
                            solidHeader = TRUE, status = "primary",
          mod_display_image_ui("display_image_1")
        )
      )
    )
  })

  output$tab3UI <- renderUI({
    fluidPage(
      fluidRow(
        shinydashboard::box(width = 12, height = 750, collapsible = TRUE, title = "Plot",
                            solidHeader = TRUE, status = "primary",
          mod_display_plot_ui("mod_display_plot_1")
        )
      )
    )
  })

  output$tab4UI <- renderUI({
    fluidPage(
      fluidRow(
        shinydashboard::box(width = 12, height = 750, collapsible = TRUE, title = "Table",
                            solidHeader = TRUE, status = "primary",
          mod_display_table_ui("display_table_1")
        )
      )
    )
  })

  # server modules -------------------------------------------------------------
  mod_values <- reactiveValues()
  mod_upload_server("upload_1", mod_values = mod_values)
  mod_filter_permission_server("filter_1", mod_values = mod_values)
  mod_display_image_server("display_image_1", mod_values = mod_values)
  mod_display_plot_server("mod_display_plot_1", mod_values = mod_values)
  mod_display_table_server("display_table_1", mod_values = mod_values)

  # timed reactivity -----------------------------------------------------------
  mod_values$timer_seconds <- 0

  observe({
    # mod_values$timer_seconds <- isolate(mod_values$timer_seconds) + get_golem_config("timer_seconds")
    # invalidateLater(get_golem_config("timer_seconds") * 1000) # milliseconds
    mod_values$timer_seconds <- isolate(mod_values$timer_seconds) + 4
    invalidateLater(4 * 1000) # milliseconds
  })

  observeEvent(mod_values$timer_seconds,
               notify(glue::glue("Running for {isolate(mod_values$timer_seconds)} seconds ..."), duration = 1))
}
