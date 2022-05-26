
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

# Shiny example app

This shiny package is an example shiny app created using the [golem
package](https://github.com/ThinkR-open/golem) and using shiny modules.
It demonstrates many of the shiny techniques described in Hadley
Wickham’s [Mastering Shiny](https://mastering-shiny.org/) book and
[Engineering Production-grade Shiny
Apps](https://engineering-shiny.org/) written by Colin Fay, Sébastien
Rochette, Vincent Guyader and Cervan Girad from
[Thinkr](https://rtask.thinkr.fr/).

Additional resources for developing shiny apps include

-   [Shiny
    cheatsheet](https://shiny.rstudio.com/images/shiny-cheatsheet.pdf)
-   [Shiny community](https://community.rstudio.com/c/shiny/8)
-   [Awesome Shiny
    Extensions](https://github.com/nanxstats/awesome-shiny-extensions)
-   [Shiny gallery](https://shiny.rstudio.com/gallery/)

The shiny app contains a number of shiny modules, demonstrating the use
of differing shiny functionality

-   **upload module** uploads a csv data file into the shiny app.
-   **filter module** dynamically populates input controls drop down
    options, applying validation to the input values using the
    [shinyvalidate]((https://rstudio.github.io/shinyvalidate)) package
    and managing permission to display the filtered data.
-   **display image module** displays the species image and link to
    original species image.
-   **display plot module** displays and download the species plot and
    select data points using the brush option functionality. Width and
    height of the image can be altered using input controls in a modal
    dialog.
-   **display table module** displays and downloads the species table.

Shiny
[notification](https://shiny.rstudio.com/articles/notifications.html)
functionality is used in the modules to notify when a reactive values is
returned from the module.

# Publication

The [example shiny app](https://gcfrench.shinyapps.io/shinystore) has
been deployed on shinyapps.io, with the code on
[github](https://github.com/gcfrench/shinystore)
