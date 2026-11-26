keep <- function(input, fun) {
  input[sapply(input, fun)]
}

discard <- function(input, fun) {
  input[!sapply(input, fun)]
}
