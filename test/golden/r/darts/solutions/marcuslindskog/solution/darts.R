score <- function(x, y) {
  r <- sqrt(x^2 + y^2)
  points <- 0
  if (r <= 1) {
    points <- 10
  }else if (r <= 5){
    points <- 5
  }else if (r <= 10){
    points <- 1
  }
  return(points)
}

