#' @title
#' display table UI Function
#'
#' @description
#' Shiny module to display and download table using dataTableOutput and downloadHandler
#' control.
#'
#' @details
#' * [reactable tables](https://glin.github.io/reactable)
#'
#' @param id Internal parameters for {shiny}.
#'
#' @importFrom shiny NS tagList
#' @export
mod_display_table_ui <- function(id){
  ns <- NS(id)
  tagList(
    dataTableOutput(ns("species_table")),
    uiOutput(ns("species_download")),
  )
}

#' @title
#' Shiny module display table server function
#'
#' @description
#' This shiny module displays and downloads a table of the filtered data,
#'
#' * check validated filter data available and has permission to display table.
#' * displays the table of the filtered data.
#' * add download button to download filtered data.
#'
#' @details
#' * [DataTables options](https://datatables.net/reference/option)
#' * [Parameterized reports](https://shiny.rstudio.com/articles/generating-reports.html)
#'
#' @export
mod_display_table_server <- function(id, mod_values){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # check permission and create table
    table <- reactive({

      # check permission to display table
      req(mod_values$display_table)

      # check filtered data ready
      req(mod_values$filter_data)

      # create table
      mod_values$filter_data
    })

    # display filtered data in table
    output$species_table <- renderDataTable(
      table(), options= list(pageLength = 5)
    )

    # add download button
    output$species_download <- renderUI ({

      # check permission to display plot
      req(mod_values$display_table)

      # check filtered data ready
      req(mod_values$filter_data)

      # Add download button
      downloadButton(ns("download_table"), "Download table",
                     class = "btn-sm btn-primary")
    })

    # download filtered data
    output$download_table <- downloadHandler(

      filename = function() {
        glue::glue("{mod_values$species_selected}_{mod_values$species_year}.csv")
      },
      content = function(file){
        readr::write_csv(table(), file)
      }
    )
  })
}

## To be copied in the UI
# mod_display_table_ui("display_table_1")

## To be copied in the server
# mod_display_table_server("display_table_1")
