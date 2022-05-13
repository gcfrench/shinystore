#' @title
#' Show notification
#'
#' @description
#' Function showing a notification message on the bottom right of the User Interface
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
