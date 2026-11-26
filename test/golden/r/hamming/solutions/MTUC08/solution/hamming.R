# This is a stub function to take two strings
# and calculate the hamming distance
hamming <- function(strand1, strand2) {
  # check if strands are equal length
  if (nchar(strand1) != nchar(strand2)) {
    stop("strands are not equal length")
  } else {
    # split input strings into vectors of characters
    strand1 <- unlist(strsplit(strand1, ""))
    strand2 <- unlist(strsplit(strand2, ""))
  
    # count the number of different characters
    length(strand2[strand1 != strand2])
  }
}
