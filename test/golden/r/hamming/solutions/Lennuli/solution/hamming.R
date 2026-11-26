# This is a stub function to take two strings
# and calculate the hamming distance
hamming <- function(strand1, strand2) {
  stopifnot(nchar(strand1)==nchar(strand2))
  return(length(which(strsplit(strand1,"")[[1]]!=strsplit(strand2,"")[[1]])))
}
