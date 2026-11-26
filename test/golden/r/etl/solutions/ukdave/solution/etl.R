etl <- function(input) {
  result <- list()
  for (score in names(input)) {
    for (letter in input[score]) {
      result[tolower(letter)] = as.integer(score)
    }
  }
  result[order(names(result))]
}
