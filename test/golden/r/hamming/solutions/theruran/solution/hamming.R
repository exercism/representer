# This is a stub function to take two strings
# and calculate the hamming distance
hamming <- function(strand1, strand2) {
  stopifnot(nchar(strand1) == nchar(strand2))
  s1 <- strsplit(strand1, "")[[1]]
  s2 <- strsplit(strand2, "")[[1]]
  distance <- sum(table(vector("logical", length(s1)) != (s1 == s2))["FALSE"])
  return (if (is.na(distance)) 0 else distance)
}
