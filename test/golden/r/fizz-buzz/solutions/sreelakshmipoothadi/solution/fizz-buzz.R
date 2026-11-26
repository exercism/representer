fizz_buzz <- function(n) {
  result <- character(n)
  for (i in 1:n) {
    if (i %% 3 == 0 && i %% 5 == 0) {
      result[i] <- "Fizz Buzz"
    } else if (i %% 3 == 0) {
      result[i] <- "Fizz"
    } else if (i %% 5 == 0) {
      result[i] <- "Buzz"
    } else {
      result[i] <- as.character(i)
    }
  }
  return(result)
}
