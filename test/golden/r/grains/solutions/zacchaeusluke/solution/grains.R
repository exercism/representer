square <- function(n) {
  if (n %in% 1:64) return(2^(n-1))
  else stop("Number not in range")
}

total <- function() {
  sum(2^(0:63))
}