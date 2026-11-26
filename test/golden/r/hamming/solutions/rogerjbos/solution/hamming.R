# This is a stub function to take two strings
# and calculate the hamming distance
hamming <- function(strand1, strand2) {
  stopifnot(nchar(strand1) == nchar(strand2))
  sum(!Reduce(f = function(s1, s2) {s1 == s2}, x = strsplit(c(strand1, strand2), "")))
}