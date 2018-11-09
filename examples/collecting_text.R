library(callbackConnection)

.callback_aggregator <<- ""

callback <- function(txt) {
  .callback_aggregator <<- paste0(.callback_aggregator, txt)
  if (any(grepl("\\n|\\r", txt))) {
    rstudioapi::showDialog("Callback Connection", .callback_aggregator)
    .callback_aggregator <<- ""
  }
}

con <- callbackConnection(callback)
sink(con, type="message")
sink(con, type="output", split = TRUE)

# close down sink
sink(type="output")
sink(type="message")
close(con)
