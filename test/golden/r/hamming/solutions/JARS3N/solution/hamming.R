# This is a stub function to take two strings
# and calculate the hamming distance

hamming <- function(strand1, strand2) {
s<-strsplit(c(strand1,strand2),split="")
if(length(s[[1]])==length(s[[2]])){
  sum(s[[1]]!=s[[2]])
}else{stop()}
}
