score <- function(x, y) {
  z <- sqrt(x * x + y * y)
  if (z > 10) {
    0
  } else if (z > 5) {
    1
  } else if (z > 1) {
    5
  } else {
    10
  }
}
