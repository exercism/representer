sieve <- function(limit) {
  # which(FALSE) produces integer(0), not c() as required
  if (limit == 1) return(c())
  
  s <- rep(TRUE, limit)
  s[1] <- FALSE # 1 is not a prime number
  for (k in 2:limit) {
    if (s[k] == TRUE) {
      if (2*k <= limit) { 
        s[seq.int(2*k,limit,k)] <- FALSE
      }
    }
  }
  which(s)
}
