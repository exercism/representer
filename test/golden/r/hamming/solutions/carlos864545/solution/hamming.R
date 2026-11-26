# This is a stub function to take two strings
# and calculate the hamming distance
hamming <- function(strand1, strand2) {
  contador <- 0
  
  if (nchar(strand1) != nchar(strand2)) {
    stop("Las cadenas no tienen la misma longitud.")
  }
  
  for (i in 1:nchar(strand1)) {
    if (substr(strand1, i, i) != substr(strand2, i, i)) {
      contador <- contador + 1
    }
  }
  
  return(contador)
}

hamming("GAGCCTACTAACGGGAT", "CATCGTAATGACGGCCT")
