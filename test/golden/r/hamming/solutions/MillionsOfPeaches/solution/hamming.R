# This is a stub function to take two strings
# and calculate the hamming distance
hamming <- function(strand1, strand2) {
  strand1_vec <- unlist(strsplit(strand1, NULL))
  strand2_vec <- unlist(strsplit(strand2, NULL))
  
  stopifnot(length(strand1_vec) == length(strand2_vec))
  
  return(sum(strand1_vec != strand2_vec))
}
