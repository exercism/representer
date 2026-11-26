scale <- function(point, s) {
  point * s
}

translate <- function(point, ...) {
  point - c(...)
}

transform2d <- function(dx, dy, s=1) {
  make_point <- function(point) {
    (point + c(dx,dy))*s
  }
    
}

transform3d <- function(dx, dy, dz, s=1) {
  tf3d <- function(point) {
    (point + c(dx,dy,dz))*s
  }
}
