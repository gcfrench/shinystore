#' @title
#' display table UI Function
#'
#' @description
#' Shiny module to display table using dataTableOutput control.
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
    dataTableOutput(ns("species_table"))
  )
}

#' @title
#' Shiny module display table server function
#'
#' @description
#' This shiny module displays a table of the filtered data,
#'
#' * check validated filter data available and has permission to display table.
#' * displays the table of the filtered data.
#'
#' @details
#' * [DataTables options](https://datatables.net/reference/option)
#'
#' @export
mod_display_table_server <- function(id, mod_values){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
      output$species_table <- renderDataTable({

        # check permission to display plot
        req(mod_values$display_table)

        # check filtered data ready
        req(mod_values$filter_data)

        # create table
        mod_values$filter_data
      })
  })
}

## To be copied in the UI
# mod_display_table_ui("display_table_1")

## To be copied in the server
# mod_display_table_server("display_table_1")
