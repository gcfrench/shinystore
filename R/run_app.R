#' @title
#' Run the Shiny Application
#'
#' @details
#'
#' * [Shiny cheatsheet](https://shiny.rstudio.com/images/shiny-cheatsheet.pdf)
#' * [Shiny community](https://community.rstudio.com/c/shiny/8)
#' * [Awesome Shiny Extensions](https://github.com/nanxstats/awesome-shiny-extensions)
#' * [Shiny gallery](https://shiny.rstudio.com/gallery/)
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  onStart = NULL,
  options = list(),
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
