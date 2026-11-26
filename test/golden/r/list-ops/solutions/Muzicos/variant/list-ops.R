my_length <- function(x) {
  i <- 0
  
  for (e in x) {
    i <- i + 1
  }
  
  i
}

my_reverse <- function(x) {
  output <- vector("list", my_length(x))
  
  for (i in my_length(x):1) {
    output[i] <- x[my_length(x) - i + 1]
  }
  
  output
}

my_map <- function(x, f) {
  output <- list()
  
  for (e in x) {
    output <- c(output, f(e))
  }
  
  output
}

my_filter <- function(x, f) {
  if (my_length(x) >= 0) x[unlist(my_map(x, f))] else x
}

my_append <- function(x, y) {
  c(x, y)
}

my_concat <- function(x) {
  output <- if (my_length(x) > 0) x[[1]] else x
  
  if (my_length(x) > 1) {
    for (i in 2:my_length(x)) {
      output <- my_append(output, x[[i]])
    }
  }
  
  output
}

my_foldl <- function(x, f, init) {
  acc <- init
  
  for (e in x) {
    acc <- f(acc, e)
  }
  
  acc
}

my_foldr <- function(x, f, init) {
  acc <- init
  
  for (e in my_reverse(x)) {
    acc <- f(acc, e)
  }
  
  acc
}
