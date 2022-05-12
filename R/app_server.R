#' @title
#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#' @param mod_values a 'reactiveValues() list storing returned values from server modules,
#' containing the following elements
#'
#' * 'upload_data' uploaded csv file as data frame.
#' * 'species_list' list of species in uploaded csv file.
#' * 'year_list' list of years in uploaded csv file.
#' # 'filter_data' uploaded csv file filtered by species and year list.
#'
#' @import shiny
#'
#' @export
app_server <- function(input, output, session) {
  mod_values <- reactiveValues()
  mod_upload_server("upload_1", mod_values = mod_values)
  mod_filter_server("filter_1", mod_values = mod_values)
}
