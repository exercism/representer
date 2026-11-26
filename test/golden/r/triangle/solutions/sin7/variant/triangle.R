triangle <- function(x, y, z) {
  # equilateral three sides the same length.
  # isosceles triangle has at least two sides the same length.
  # scalene triangle has all sides of different lengths.
  if (x == 0 || y == 0 || z == 0){
    stop('error')
  }

  if (x - y < z || z + y < x || x + z < y){
    stop('error')
  }

  ans <- paste0("triangle(", x, ", ", y, ", ", z, ")")

  if (x == y && x == z && y == z){
    class(ans) <- append(class(ans), "equilateral")
  }

  if (sum(x == y, x == z, y == z) >= 1){
    class(ans) <- append(class(ans), "isosceles")
  }

  if (sum(x == y, x == z, y == z) == 0){
    class(ans) <- append(class(ans), "scalene")
  }
 
  return(ans)
}

x <- 4
y <- 4
z <- 4
