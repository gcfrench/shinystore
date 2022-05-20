#' @title
#' display image UI Function
#'
#' @description
#' Shiny module to display html text and image using htmlOutput and imageOutput
#' controls.
#'
#' @details
#' [Render images in a Shiny app](https://shiny.rstudio.com/articles/images.html)
#'
#' @param id Internal parameters for {shiny}.
#'
#' @importFrom shiny NS tagList
#' @export
mod_display_image_ui <- function(id){
  ns <- NS(id)
  tagList(
    htmlOutput(ns("species_image_source")),
    imageOutput(ns("species_image"), height = "350px")
  )
}

#' @title
#' Shiny module display image server function
#'
#' @description
#' This shiny module uses the filtered dataset and selected species from the filter
#' module to
#'
#' * display html link to the original image.
#' * display an image of the penguin species.
#'
#' @details
#' * [Render images in a Shiny app](https://shiny.rstudio.com/articles/images.html)
#'
#' @export
mod_display_image_server <- function(id, mod_values){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$species_image_source <- renderUI({
      req(mod_values$species_selected)
      info <- shinystore::species_images %>%
        dplyr::filter(species == mod_values$species_selected)
      HTML(glue::glue("<p>
                              <a href='https://unsplash.com/photos/{info$id}'>original</a> by
                              <a href='https://unsplash.com/@{info$author}'>{info$author}</a>
                              </p>"))
    })

    output$species_image <- renderImage({
      req(mod_values$species_selected)
      list(
        src = fs::path("inst", "app", "www", glue::glue("{mod_values$species_selected}.jpg")),
        width = 211,
        height = 317
      )
    }, deleteFile = FALSE)
  })
}

## To be copied in the UI
# mod_display_image_ui("display_image_1")

## To be copied in the server
# mod_display_image_server("display_image_1")
