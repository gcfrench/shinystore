#' @title
#' Shiny module tour guide function
#'
#' @description A shiny Module to display a walk through tour-guide of shiny modules
#' and their controls
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @importFrom shiny NS tagList
#' @export
mod_tour_guide_ui <- function(id){
  ns <- NS(id)
  tagList(
    actionButton(ns("tour_guide"), "Guide",
                 icon = icon("info-circle"),
                 class = "btn-sm btn-success")
  )
}

#' @title
#' Shiny module tour guide server function
#'
#' @description
#' This shiny modules provides the tour guide information boxes using cicerone
#' package.
#'
#' @details
#'
#' * [cicerone](https://cicerone.john-coene.com/) - creates guided tours using driver.js library.
#' * [conductor](https://conductor.etiennebacher.com/) - creates guided tours using shephard.js library.
#' * [rintrojs](https://carlganz.github.io/rintrojs/) - creates guided tours using Intro.js library.
#' * [Colin Fay hexmake tour guide module](https://github.com/ColinFay/hexmake/blob/master/R/mod_guided_tour.R)
#'
#' @param id Internal parameter for {shiny}.
#' @param mod_values reactiveValues() list containing server module returned values
#'
#' @export
mod_tour_guide_server <- function(id, mod_values){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(input$tour_guide, {

      golem::invoke_js(
        "drive", list(arg = TRUE)
      )
      tour_guide <- cicerone::Cicerone$
        new(
          allow_close = TRUE,
          opacity = 0.75,
          stage_background = "transparent"
        )
      purrr::pmap(
        data.frame(
          el = c(
            ns("upload")
          ),
          title = c(
            "Upload module"
          ),
          description = c(
            "File input control."
          )
        ), ~ {
          tour_guide$step(
            ..1, ..2, ..3
          )
        }
      )
      tour_guide$
        init()$
        start()

      # notification message
      notify("Guide not currently working ", duration = 1)

    })
  })
}


## To be copied in the UI
# mod_tour_guide_ui("tour_guide_1")

## To be copied in the server
# mod_tour_guide_server("tour_guide_1")
