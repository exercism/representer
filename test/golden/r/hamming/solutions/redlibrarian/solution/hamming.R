# This is a stub function to take two strings
# and calculate the hamming distance

convert <- function(s){
  unlist(strsplit(s, ""))
}

hamming <- function(strand1, strand2) {
  if(nchar(strand1) == nchar(strand2)){
    return(length(which(convert(strand1)!= convert(strand2))))
  } else {
    stop("Sequences are not the same length")
  }
}
