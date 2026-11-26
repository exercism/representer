number_type <- function(n){
  if(n <= 0) {
    stop("n must be a natural number.")
  } else if(n == 1) {
    numtype <- "deficient"
  } else {
    lower_numbers <- (n-1):1
    factors <- lower_numbers[n%%lower_numbers == 0]
    aliquot_sum <- sum(factors)
    diff <- aliquot_sum - n
    if(diff == 0) {
      numtype <- "perfect"
    } else if(diff > 0) {
      numtype <- "abundant"
    } else if(diff < 0) {
      numtype <- "deficient"
    }
  }
  return(numtype)
}