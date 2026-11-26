# This is a stub function to take two strings
# and calculate the hamming distance
hamming <- function(a,b) {
  nchar(a)-nchar(b)&&stop();c=strsplit(c(a,b),'');return(sum(c[[1]]!=c[[2]]))}