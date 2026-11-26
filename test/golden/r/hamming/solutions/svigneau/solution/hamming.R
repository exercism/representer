# This is a stub function to take two strings
# and calculate the hamming distance
hamming <- function(strand1, strand2) {
  if (nchar(strand1) != nchar(strand2)) {
    stop('The two strands should have the same length.')
  }
  sum(unlist(strsplit(strand1, '')) != unlist(strsplit(strand2, '')))
}
