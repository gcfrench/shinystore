#' @title
#' Show notification
#'
#' @description
#' Function showing a notification message on the bottom right of the User Interface
#'
#' @details
#' * [Shiiny notifications](https://shiny.rstudio.com/articles/notifications.html)
#'
#' @param msg notification text message to be displayed
#' @param id internal notification id
#' @param duration duration of notification message in seconds.
#'
#' @export
notify <- function(msg, id = NULL, duration = NULL) {
  shiny::showNotification(msg, id = id, duration = duration,
                          closeButton = FALSE, type = "message")
}

#' @title
#' Shiny tour guide
#'
#' @description
#' Tour of the shiny app
#'
#' @details
#' * [Conductor](https://conductor.etiennebacher.com)
#' * [rintrojs](https://github.com/carlganz/rintrojs)
#' * [cicerone](https://cicerone.john-coene.com/index.html)
#'
#' @export
tour_guide <- conductor::Conductor$new()
