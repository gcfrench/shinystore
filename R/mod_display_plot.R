#' @title
#' Shiny module display and download plot UI Function
#'
#' @description
#' Shiny module to display and save a plot using plotOutput and downloadHandler controls
#' and table from brush option using tableOutput control. Width and height of saved
#' plot image can be altered using a sliderInput controls in a shiny modal form.
#'
#' @details
#'
#' Progress and spinner bars
#' * [shiny withProgress](https://shiny.rstudio.com/articles/progress.html)
#' * [shinycssLoaders](https://github.com/daattali/shinycssloaders)
#' * [waiter](waiter: https://github.com/JohnCoene/waiter)
#'
#' Plots
#' * [plot input](https://gallery.shinyapps.io/095-plot-interaction-advanced)
#'
#'     + click = clickOpts(id = "plot_click", ...)
#'     + dblclick = dblClickOpts(id = "plot_dblclick", ...)
#'     + hover = hoverOpts(id = "plot_hover", ...)
#'     + brush = brushOpts(id = "plot_brush", ...)
#'
#' Caching
#' * [Using caching in Shiny to maximize performance](https://shiny.rstudio.com/articles/caching.html)
#' * [Using bindCache() to speed up an app](https://shiny.rstudio.com/app-stories/weather-lookup-caching.html)
#'
#' @param id Internal parameters for {shiny}.
#'
#' @importFrom shiny NS tagList
#' @export
mod_display_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
    column(5,
           shinycssloaders::withSpinner(plotOutput(ns("species_plot"),
                                                   brush = brushOpts(id = ns("plot_brush"),
                                                                     fill = "gold", stroke = "black",
                                                                     resetOnNew = TRUE),
                                                   height = "500px"),
                                        color = "#357f2e"),
           uiOutput(ns("species_plot_save")),
    ),
    column(7,
           tableOutput(ns("species_plot_selected"))
    )
  )
}

#' @title
#' Shiny module display and download plot server function
#'
#' @description
#' This shiny module creates, displays and saves a plot of the filtered data on top of the upload data,
#'
#' * check validated filter data available and has permission to display plot.
#' * check for presence of example invalid values for plot.
#' * creates a plot of the filtered data on top of the upload data.
#' * displays the plot of the filtered data on top of the upload data.
#' * provides brush option displaying the selected data in a table.
#' * adds a save button to save the plot.
#' * provides inputSlider controls to change save parameters of the plot image in a modal dialog.
#'
#' @details
#' * [Validate input values](https://shiny.rstudio.com/reference/shiny/0.14/validate.html)
#' * [plotly](https://plotly-r.com/)
#' * [plot input](https://gallery.shinyapps.io/095-plot-interaction-advanced)
#'
#'     + nearPoints: plot_click, plot_dblclick, plot_hover
#'     + brushedPoints: plot_brush
#'
#' @export
mod_display_plot_server <- function(id, mod_values){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # check permission and create plot -----------------------------------------
    plot <- reactive({

      # check permission to display plot
      req(mod_values$display_plot)

      # check filtered data ready
      req(mod_values$filter_data)

      # create plot
      ggplot2::ggplot(data = mod_values$upload_data, ggplot2::aes(x = flipper_length_mm, y = body_mass_g)) +
        ggplot2::geom_point(size = 2, colour = "grey", alpha = 0.6) +
        ggplot2::geom_point(data = mod_values$filter_data,
                            ggplot2::aes(x = flipper_length_mm, y = body_mass_g),
                            size = 2, colour = "steelblue") +
        ggplot2::theme_bw()
    })

    # display plot -------------------------------------------------------------
    output$species_plot <- renderPlot({

      # check presence of example invalid values for plot
      if(mod_values$species_selected == "Gentoo" && mod_values$species_year == 2008) {
        validate("Unable to plot Gentoo measurements for 2008.")
      }

      plot()
    }, res = 96) %>%
      bindCache(plot())

    # display table of data for brushed points
    output$species_plot_selected <- renderTable({
      req(input$plot_brush)
      brushedPoints(mod_values$filter_data, input$plot_brush)
    })

    # add save button ----------------------------------------------------------
    output$species_plot_save <- renderUI ({

      # require created plot
      plot()

      # check presence of example invalid values for plot
      if(mod_values$species_selected == "Gentoo" && mod_values$species_year == 2008) {
        validate("Unable to save Gentoo measurements for 2008.")
      }

      # Add download button
      actionButton(ns("save_plot_modal"), "Save plot",
                   icon = icon("download"),
                   class = "btn-sm btn-success")
    })

    # modal form ---------------------------------------------------------------
    modal_save <- modalDialog(

      # title
      title = "Width and height of plot image",

      # body
      sliderInput(ns("image_width"), "Width of plot image in inches", value = 6, min = 3, max = 12),
      sliderInput(ns("image_height"), "Height of plot image in inches", value = 6, min = 3, max = 12),

      # footer
      footer = tagList(
        downloadButton(ns("save_plot"), "Save plot",
                       class = "btn-sm btn-success"),
        actionButton(ns("finish"), "Finish",
                     class = "btn-sm btn-success"),
      )
    )

    observeEvent(input$save_plot_modal, {
      showModal(modal_save)
    })

    observeEvent(input$image_width, {
      mod_values$image_width <- input$image_width
    })

    observeEvent(input$image_height, {
      mod_values$image_height <- input$image_height
    })

    observeEvent(input$finish, {
      removeModal()
    })

    # save plot ----------------------------------------------------------------
    output$save_plot <- downloadHandler(
      filename =  function() {
        glue::glue("{mod_values$species_selected}_{mod_values$species_year}.png")
      },
      content = function(file) {
        ggplot2::ggsave(filename = file,
                        plot = plot(),
                        device = ragg::agg_png,
                        width = mod_values$image_width,
                        height = mod_values$image_height,
                        units = "in",
                        dpi = 72)
      }
    )
  })
}

## To be copied in the UI
# mod_display_plot_ui("mod_display_plot_1")

## To be copied in the server
# mod_display_plot_server("mod_display_plot_1")
