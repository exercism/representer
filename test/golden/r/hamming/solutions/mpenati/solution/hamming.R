# This is a stub function to take two strings
# and calculate the hamming distance
hamming <- function(strand1, strand2) {
    nchar_strand1 <- nchar(strand1)
    nchar_strand2 <- nchar(strand2)

    if (nchar_strand1 != nchar_strand2)
        stop("Strands must be of the same size")
   
    sum(
        substring(strand1, 1:nchar_strand1, 1:nchar_strand1) != 
            substring(strand2, 1:nchar_strand2, 1:nchar_strand2)
    )
}
