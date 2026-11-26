
distance <- function(x, y) {
  return(sqrt((x^2) + (y^2)))
}

score <- function(x, y) {
  d <- distance(x, y)
  # outside
  if (d > 10) {
    return(0)
  }
  # outter circle
  if (d <= 10 && d > 5) {
    return(1)
  }
  # middle circle
  if (d <= 5 && d > 1) {
    return(5)
  }
  # inner circl
  if (d <= 1) {
    return(10)
  }
}
