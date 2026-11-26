# This is a stub function to take two strings
# and calculate the hamming distance
hamming <- function(strand1, strand2) {
  #If the strings haven't the same size, an exception is raised
  if((nchar(strand1) - nchar(strand2)) != 0){
    stop("Error : The strains don't have equal length.")
  }
  error = 0
  #For each letter of both strands, "error" is incremented when there is a difference between them
  for (i in 1:nchar(strand1)){
    if(substr(strand1, i, i) != substr(strand2, i, i)){
      error = error + 1
    }
  }
  error
}
