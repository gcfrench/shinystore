#' @title
#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#' @param mod_values a 'reactiveValues() list storing returned values from server modules,
#' containing the following elements
#'
#' * 'upload_data' uploaded csv file as data frame
#'
#' @import shiny
#'
#' @export
app_server <- function(input, output, session) {
  mod_values <- reactiveValues()
  mod_upload_server("upload_1", mod_values = mod_values)
}
