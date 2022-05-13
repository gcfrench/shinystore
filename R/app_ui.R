#' @title
#' The application User-Interface
#'
#' @description
#' The application user-interface separated as pages with the first page containing
#' the upload module.
#'
#' @details
#'
#' * [bslib R package](https://rstudio.github.io/bslib) providing tools for
#' customizing Bootstrap themes.
#' * [Bootswatch theme](https://bootswatch.com/) Free themes for bootstrap.
#' * [Shiny layout](https://shiny.rstudio.com/articles/layout-guide.html)
#' * [shinydashboard](http://rstudio.github.io/shinydashboard/get_started.html)
#' * [shinywidgets](https://github.com/dreamRs/shinyWidgets)
#' * [sortable](https://rstudio.github.io/sortable/)
#' * [colourpicker](https://github.com/daattali/colourpicker)
#'
#' @param request Internal parameter for `{shiny}`.
#'
#' @import shiny
#'
#' @export
app_ui <- function(request) {

  # first page containing upload module
  ui_page_1 <- sidebarLayout(
    sidebarPanel(width = 3,
                 mod_upload_ui("upload_1", dataset_name = "penguin"),
                 mod_filter_ui("filter_1", dataset_name = "penguin")
    ),
    mainPanel(
      mod_display_ui("display_1")
    )
  )

  # UI layout
  tagList(
    golem_add_external_resources(),
    fluidPage(
      h1(""),
      tabsetPanel(
        id = "wizard",
        type = "hidden",
        tabPanel("page_1",
                 ui_page_1
        )
      )
    )
  )
}

#' @title
#' Add external Resources to the Application
#'
#' @description
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#'
#' @export
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "shinystore"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
