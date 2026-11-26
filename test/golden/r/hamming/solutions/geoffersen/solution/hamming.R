hamming <- function(strand1, strand2) {
  
  if(nchar(strand1) != nchar(strand2)) stop("uneven strand length")
  
  # Convert strings to lists to vectors and compare vectors
  a <- unlist(strsplit(strand1,split = ""))
  b <- unlist(strsplit(strand2,split = ""))
  sum(a != b)
}
