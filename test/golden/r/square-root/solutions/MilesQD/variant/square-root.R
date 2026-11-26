square_root <- function(number) {
  if (number > 0) {
    xn <- c(number)
    err <- 1
    while(err != 0) {
      xn <- c(0.5 * (xn[1]-(number/xn[1])), xn)
      err <- xn[1] - xn[2]
    }
    return(xn[1])
  }
  else {
    stop("Cannot process numbers equal to or less than 0")
  }
}
