#' @title
#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#'
#' @details
#' See `?golem::get_golem_options` for more details.
#'
#' * [sanitize errors](https://shiny.rstudio.com/articles/sanitize-errors.html)
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
