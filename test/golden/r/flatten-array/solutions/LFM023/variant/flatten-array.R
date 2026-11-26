flatten <- function(input) {
  result <- unlist(input, recursive = FALSE)
  result[!is.na(result) & !is.null(result)]
}
