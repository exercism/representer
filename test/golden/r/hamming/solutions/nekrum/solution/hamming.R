# This is a stub function to take two strings
# and calculate the hamming distance
hamming <- function(strand1, strand2) {
  if(nchar(strand1) != nchar(strand2)) {
    stop("Differente strand's length ")
  }
  if(strand1 == strand2) {
    return(0)
  }
  sum(Reduce(`!=`, strsplit(c(strand1, strand2), split = "")))
}
