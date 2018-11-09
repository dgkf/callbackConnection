library(callbackConnection)
library(shiny)
library(shinyjs)

options(
  shiny.fullstacktrace = TRUE,
  shiny.sanitize.errors = TRUE)

ui <- function() {
  fluidPage(
    shinyjs::useShinyjs(),
    selectInput("selection",
      "Select Something:",
      c("print something", "message something", "error something")),
    verbatimTextOutput("out")
  )
}

srv <- function(input, output, session) {
  .callback_aggregator <<- ""
  
  callback <- function(output) {
    .callback_aggregator <<- paste0(.callback_aggregator, output)
  
    if (any(grepl("[\r\n]", output))) {
      shinyjs::runjs(sprintf(
        "console.log('%s');",
        gsub("[\r\n]", "", .callback_aggregator)))
      .callback_aggregator <<- ""
    }
  }
  
  con <<- callbackConnection(callback)
  sink(con, type="message")
  sink(con, type="output", split = TRUE) # split = TRUE doesn't relay original value

  output$out <- renderText({
    if (input$selection %in% "error something") {
      stop(input$selection) # cause an error
    } else if (input$selection %in% "message something") {
      message(input$selection)
    } else {
      print(input$selection) # having issues splitting this - console output just says "rval"
    }

    input$selection
  })
}

shinyApp(ui, srv)

sink(type="output")
sink(type="message")
close(con)
