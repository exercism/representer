hamming <- function(v1, v2) {
  v <- strsplit(c(v1,v2), "")
  names(v) <- c("one", "two")
  if (length(v$one) != length(v$two)) { stop("Error") } else { length(which( v$one != v$two )) }
}
