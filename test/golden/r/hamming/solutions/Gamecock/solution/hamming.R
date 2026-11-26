# This is a stub function to take two strings
# and calculate the hamming distance
hamming <- function(strand1, strand2) {
        if ( nchar(strand1) != nchar(strand2)) stop("Strands must be the same length.")
        s1 <- strsplit(strand1, "")
        s2 <- strsplit(strand2, "")
        length(which(s1[[1]] != s2[[1]]))
}
