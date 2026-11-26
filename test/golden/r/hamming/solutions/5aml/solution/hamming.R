hamming <- function(string1, string2) {

  if (nchar(string1) != nchar(string2)) {
    stop("Strings must be of equal length to calculate Hamming distance.")
  }
  
  # Convert the strings to character vectors for easier comparison
  string1_chars <- unlist(strsplit(string1, ""))
  string2_chars <- unlist(strsplit(string2, "")) 

  # Calculate Hamming distance by comparing characters at each position
  hamming_distance <- sum(string1_chars != string2_chars)
  
  return(hamming_distance)
}
