#' @title
#' Shiny module upload UI Function
#'
#' @description Shiny module uploading csv file using fileInput control.
#'
#' @details
#' * [Uploading files](https://shiny.rstudio.com/articles/upload.html) using fileInput control.
#'
#' @param id Internal parameter for {shiny}.
#' @param dataset_name Name of dataset to upload.
#'
#' @importFrom shiny NS tagList
#' @export
mod_upload_ui <- function(id, dataset_name){
  ns <- NS(id)
  tagList(
    fileInput(ns("upload"), glue::glue_safe("Upload {dataset_name} data"), accept = ".csv")
  )
}

#' @title
#' Shiny module upload server function
#'
#' @description
#' This shiny modules provides the upload control to
#'
#' * select csv file to upload.
#' * upload and return data from csv file.
#' * send notification of uploaded data.
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

    ## Shiny tour
    tour_guide$step(
      el = ns("upload"),
      title = "Upload module",
      text = "File input control."
    )

    ## Reactive expression
    upload_data <- reactive({
      req(input$upload)
      readr::read_csv(input$upload$datapath)
    })

    ## Return reactive value stored in mod_values reactiveValues
    observeEvent(upload_data(), {
      mod_values$upload_data <- upload_data()
    })

    # Notify module returning reactive values
    observeEvent(mod_values$upload_data, {
      id <- notify(glue::glue("upload module returned {nrow(isolate(mod_values$upload_data))} rows"))
      on.exit(shiny::removeNotification(id), add = TRUE)
      Sys.sleep(1.0)
    })
  })
}

## To be copied in the UI
# mod_upload_ui("upload_1")

## To be copied in the server
# mod_upload_server("upload_1")
