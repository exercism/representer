hamming <- function(strand1, strand2) {
  if (nchar(strand1) != nchar(strand2)) {
    stop("Strands must be the same length")
  }

  diff <- 0
  for (i in 1:nchar(strand1)) {
    if (substr(strand1, i, i) != substr(strand2, i, i)) {
      diff <- diff + 1
    }
  }
  diff
}