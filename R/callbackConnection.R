#' Create a connection which executes an R function upon receiving a message
#'
#' This connection can be provided with an arbitrary R callback function that
#' will be executed silently and without producing additional output for each
#' new messag received by the connection.
#'
#' @param callback an R function to execute with each message
#' @return a new callbackConnection connection object
#'
#' @useDynLib callbackConnection R_callback_connection
#'
#' @importFrom utils capture.output
#' @export
#' 
callbackConnection <- function(callback = function(char) print(char)) {
  body(callback) <- bquote(
    try(
      invisible(utils::capture.output(.(body(callback)))),
      silent = TRUE))

  con <- .Call(R_callback_connection, callback)
  return(con)
}
