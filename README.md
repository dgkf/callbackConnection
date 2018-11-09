# callbackConnection

A new connection target for R allowing arbitrary R code execution on stdout and
stderr messages

# Example [app.R](/examples/app.R)

Changing the input of the `selectInput()` prints, emits a message or an error.

```r
# relevant snippet
output$out <- renderText({
  if (input$selection %in% "error something") {
    stop(input$selection) # cause an error
  } else if (input$selection %in% "message something") {
    message(input$selection)
  } else {
    print(input$selection)
  }

  input$selection
})
```

<p align="center">
<img src="https://user-images.githubusercontent.com/18220321/48291943-1f06ca00-e42d-11e8-94f6-9fe8fb962c3d.gif">
</p>

# Motivation

This was a proof of concept put together to alleviate my coworkers' difficulties
in accessing shiny app log files on a shared shiny server. I aimed to generalize
the problem to be able to handle arbitrary callbacks, though the primary goal
was to issue outputs to the JavaScript console in a browser using
`shinyjs::runjs()`.

For more details, please take a look at the example [app.R](/examples/app.R). 

# Known Issues

Within a shiny app, this callback is somewhat error prone and seems to cause
random crashes of the running app. It is by no means a polished product, and
hinges on some sloppy C code (my first attempt at writing C in about a
decade).
