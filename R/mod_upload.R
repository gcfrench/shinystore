#' @title
#' upload UI Function
#'
#' @description Shiny module uploading csv file using fileInput control.
#'
#' @details
#' * [Uploading files](https://shiny.rstudio.com/articles/upload.html) using fileInput control.
#'
#' @param id Internal parameter for {shiny}.
#'
#' @importFrom shiny NS tagList
#' @export
mod_upload_ui <- function(id){
  ns <- NS(id)
  tagList(
    fileInput(ns("upload"), "Upload data", accept = ".csv")
  )
}

#' @title
#' Shiny module upload server function
#'
#' @details
#' * [Reactive polling](https://shiny.rstudio.com/reference/shiny/latest/reactivePoll.html)
#' * [Reactive file reader](https://shiny.rstudio.com/reference/shiny/latest/reactiveFileReader.html)
#'
#' @param id Internal parameter for {shiny}.
#' @param mod_values reactiveValues() list containing server module returned values
#'
#' @return upload_data() reactive value containing uploaded data from csv file.
#'
#' @export
mod_upload_server <- function(id, mod_values){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    ## Reactive expression
    upload_data <- reactive({
      req(input$upload)
      readr::read_csv(input$upload$datapath)
    })

    ## Return reactive value stored in mod_values reactiveValues
    observeEvent(upload_data(), {
      mod_values$upload_data <- upload_data()
    })

  })
}

## To be copied in the UI
# mod_upload_ui("upload_1")

## To be copied in the server
# mod_upload_server("upload_1")
