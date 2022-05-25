#' @title
#' Run the Shiny Application
#'
#' @description
#' Function called to run the app, setting the golem options and running other
#' generic functions.
#'
#' @details
#' * [sanitize errors](https://shiny.rstudio.com/articles/sanitize-errors.html)
#' * [reactlog](https://rstudio.github.io/reactlog/)
#' * See `?golem::get_golem_options` for more details.
#'
#' @param ... arguments to pass to golem_opts.
#'
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  onStart = NULL,
  options = list(shiny.sanitize.errors = TRUE),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  # reactlog: Ctrl-F3 or shiny::reactlogShow()
  reactlog::reactlog_enable()

  # golem options
  with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)

  )
}
