# shinystore 0.1.0 <font size="4">2022-05-24</font>

-   Enabled [reactlog](https://rstudio.github.io/reactlog/) in run_app function, available during running shiny app using **Ctrl-F3** or after running the shiny app using **shiny::reactlogShow()**.
-   Added [sanitize errors](https://shiny.rstudio.com/articles/sanitize-errors.html) option to the run_app function.
-   Added **table module** to display and download the filtered data as a data table. The user interface is also updated adding the download button dynamically.
-   Added **plot module to** display a plot, a table of brushed points and download the plot image. The plot also has a [spinner](https://shiny.rstudio.com/articles/progress.html) progress indicator, applies further [validation](https://shiny.rstudio.com/reference/shiny/0.14/validate.html) to the data and update the user interface adding the save button dynamically.
-   Added **image module** to [display an image](https://shiny.rstudio.com/articles/images.html) and html links to the original image.
-   Added **filter module** to populate drop-down options, apply [validation](https://rstudio.github.io/shinyvalidate/) and set permissions to display the plot and table of the filtered data. It [updates the user interface](https://shiny.rstudio.com/reference/shiny/latest/renderUI.html) adding the permission buttons dynamically and uses shiny's notification functionality to return the reactive values' values and
-   Added **upload module** to [upload a csv file](https://shiny.rstudio.com/articles/upload.html) and return the data frame as a reactive value. This module includes using the shiny notification functionality to provide information on the returned uploaded data frame.
