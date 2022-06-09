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
#' * [shinydashboard](https://rstudio.github.io/shinydashboard/index.html)
#' * [shinywidgets](https://github.com/dreamRs/shinyWidgets)
#' * [sortable](https://rstudio.github.io/sortable/)
#' * [colourpicker](https://github.com/daattali/colourpicker)
#'
#' tests
#'
#' * [testthat](https://testthat.r-lib.org/index.html)
#' * [testthat snapshot tests](https://testthat.r-lib.org/articles/snapshotting.html)
#' * [testServer](https://shiny.rstudio.com/reference/shiny/1.5.0/testServer.html)
#' * [shinytest](https://rstudio.github.io/shinytest/)
#'
#' @param request Internal parameter for `{shiny}`.
#'
#' @import shiny
#'
#' @export
app_ui <- function(request) {

  shinydashboard::dashboardPage(
    shinydashboard::dashboardHeader(title = "Shiny app example"),
    shinydashboard::dashboardSidebar(
      collapsed = FALSE,
      div("Modules", style = "padding: 10px"),
      shinydashboard::sidebarMenu(id = "module_sidebar",
                                  shinydashboard::menuItem("Upload", tabName = "upload", icon = icon("upload")),
                                  shinydashboard::menuItem("Filter", tabName = "filter", icon = icon("filter")),
                                  shinydashboard::menuItem("Image", tabName = "image", icon = icon("image")),
                                  shinydashboard::menuItem("Plot", tabName = "plot", icon = icon("chart-bar")),
                                  shinydashboard::menuItem("Table", tabName = "table",icon = icon("table"))
      ),
      div("Resources", style = "padding: 10px"),
      shinydashboard::sidebarMenu(id = "resource_sidebar",
                                  shinydashboard::menuItem("Mastering Shiny", icon = icon("book"),
                                                           href = "https://mastering-shiny.org/", newtab = TRUE),
                                  shinydashboard::menuItem("Engineering Production-grade", icon = icon("book"),
                                                           href = "https://engineering-shiny.org/", newtab = TRUE),
                                  shinydashboard::menuItem("Code", icon = icon("file-code-o", verify_fa = FALSE),
                                                           href = "https://github.com/gcfrench/shinystore", newtab = TRUE)
      )
    ),
    shinydashboard::dashboardBody(
      shinydashboard::tabItems(
        shinydashboard::tabItem(tabName = "upload", uiOutput("tab1UI")),
        shinydashboard::tabItem(tabName = "filter", uiOutput("tab2UI")),
        shinydashboard::tabItem(tabName = "image", uiOutput("tab3UI")),
        shinydashboard::tabItem(tabName = "plot", uiOutput("tab4UI")),
        shinydashboard::tabItem(tabName = "table", uiOutput("tab5UI"))
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
