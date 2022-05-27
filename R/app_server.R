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

  # modules
  mod_values <- reactiveValues()
  mod_upload_server("upload_1", mod_values = mod_values)
  mod_filter_permission_server("filter_1", mod_values = mod_values)
  mod_display_image_server("display_image_1", mod_values = mod_values)
  mod_display_plot_server("mod_display_plot_1", mod_values = mod_values)
  mod_display_table_server("display_table_1", mod_values = mod_values)

  # timed reactivity -----------------------------------------------------------
  # Sys.setenv(R_CONFIG_ACTIVE = "testing")
  # config <- config::get()
  mod_values$timer_seconds <- 0

  observe({
    # mod_values$timer_seconds <- isolate(mod_values$timer_seconds) + config$timer_seconds
    # invalidateLater(config$timer_seconds * 1000) # milliseconds
    mod_values$timer_seconds <- isolate(mod_values$timer_seconds) + 4
    invalidateLater(4 * 1000) # milliseconds
  })

  observeEvent(mod_values$timer_seconds,
               notify(glue::glue("Running for {isolate(mod_values$timer_seconds)} seconds ..."), duration = 1))
}
