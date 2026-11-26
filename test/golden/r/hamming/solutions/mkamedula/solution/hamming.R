# This is a stub function to take two strings
# and calculate the hamming distance
hamming <- function(strand1, strand2) {
  
  if (nchar(strand1) != nchar(strand2)){
    stop()
  }

  splits <- strsplit(c(strand1, strand2), split="")
  sum(splits[[1]]!=splits[[2]])
}
