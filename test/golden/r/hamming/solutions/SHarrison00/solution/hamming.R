# This is a stub function to take two strings
# and calculate the hamming distance
hamming <- function(strand1, strand2) {
  # Convert DNA strands to vectors
  vec1 <- strsplit(strand1,"")[[1]]
  vec2 <- strsplit(strand2,"")[[1]]
  # Check for unequal strand lengths
  if(length(vec1)!=length(vec2)) {
    stop("Strands must me equal in length")
  } 
  # Count the number of differences
  sum(vec1!=vec2)
}
