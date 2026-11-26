library(purrr)
library(dplyr)

all_15 <- function(ratings) {
  all(ratings %in% c(1, 5))
}

name_customers <- function(names, ratings) {
  map2(names, ratings, \(name, rating) list(name = name, rating = rating))
}

emphatics <- function(names, ratings) {
  name_customers(names, ratings) |>
    keep(\(x) all_15(x$rating))
}

to_binary <- function(ratings) {
  if_else(ratings != 1, 0, 1)
}

satisfactions <- function(ratings) {
  cummean(ratings)
}

