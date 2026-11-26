sieve <- function(limit) {
  if (limit == 1) return(NULL)
  primes <- 2:limit
  for (i in primes){
    primes <- primes[primes %% i != 0 | primes == i]
  }
  primes
}
 