#' @title
#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#' @param mod_values a 'reactiveValues() list storing returned values from server modules,
#' containing the following elements
#'
#' * 'upload_data' uploaded csv file as data frame.
#' * 'species_selected'' species select in selectInput input control.
#' * 'species_year' year selected in numericInput input control.
#' * 'filter_data' uploaded csv file filtered by species and year list.
#' * 'display_plot' boolean permission to display plot
#'
#' @import shiny
#'
#' @export
app_server <- function(input, output, session) {
  mod_values <- reactiveValues()
  mod_upload_server("upload_1", mod_values = mod_values)
  mod_filter_permission_server("filter_1", mod_values = mod_values)
  mod_display_image_server("display_image_1", mod_values = mod_values)
  mod_display_plot_server("mod_display_plot_1", mod_values = mod_values)
}
