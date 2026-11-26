score <- function(x, y) {
  
  dart <- sqrt(x^2 + y^2)
  
  points <- if (dart <= 1) {
    10
  } else if (dart <= 5) {
    5
  } else if (dart <= 10) {
    1
  } else if (dart > 10) {
    0
  }

  return(points)
}