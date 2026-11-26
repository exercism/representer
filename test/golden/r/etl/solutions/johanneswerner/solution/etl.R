#' Extract-transform-load problem
#'
#' @param input list of scores
#'
#' @return list of transformed scores
#'
etl <- function(input) {
  output <- list()

  for (score in names(input)) {
    output[tolower(input[[score]])] <- as.integer(score)
  }

  output[order(names(output))]
}
