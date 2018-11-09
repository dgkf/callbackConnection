# callbackConnection

A new connection target for R allowing arbitrary R code execution on stdout and
stderr messages

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
