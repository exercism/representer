triangle <- function(x, y, z) {
  
  triTests <- all(
    x + y >= z,
    x + z >= y,
    y + z >= x,
    x > 0,
    y > 0, 
    z > 0
  )
  
  if(!triTests) stop("Not a triangle")
  
  type <- "scalene"
  
  if(x == y || x == z || y == z) type <- "isosceles"
  if(x == y && y == z) type <- c("equilateral", "isosceles")
  
  structure(list(x = x, y = y, z = z), class = c(type, "triangle"))
  
}
