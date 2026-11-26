pythagorean_triplet <- function(n) {
  triplets <- list()
  
  for (a in 1:(n/3)) {
    for (b in (a+1):(n/2)) {
      c <- n - a - b
      if (a^2 + b^2 == c^2) {
        triplets <- c(triplets, list(c(a, b, c)))
      }
    }
  }
  
  return(triplets)
}

