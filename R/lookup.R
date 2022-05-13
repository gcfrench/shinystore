#' @title
#' Penguin species images
#'
#' @description
#' Images of the three penguin species in the [palmerpenguin package](https://allisonhorst.github.io/palmerpenguins/)
#' dataset used in this shiny app example. The images are taken from [Unsplash](https://unsplash.com/),
#' an outline source of royalty-free stock photographs.
#'
#' @format A tibble with `r nrow(species_images)` rows and `r ncol(species_images)` variables.
#' \describe{
#'   \item{species}{Names of the penguin species.}
#'   \item{id}{Photograph id taken used in the Unsplash website.}
#'   \item{author}{Name of photographer used in the Unsplash website.}
#' }
"species_images"
