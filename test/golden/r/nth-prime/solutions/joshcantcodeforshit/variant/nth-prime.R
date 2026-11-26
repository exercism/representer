is_prime <- function(n) {
    if (n <= 2) return(FALSE) #eliminate 0, 1 and negatives
    if (n == 2 || n == 3) return(TRUE) #allow small primes
    if (n %% 2 == 0) return(FALSE) #eliminate even numbers
    for (i in 3:sqrt(n)) { #only go up until sqrt(n) since factors larger than sqrt(n) will have a counterpart less than sqrt(n) that has already been checked
        if (n %% i == 0) return(FALSE)
    }
    return(TRUE)
}

prime <- function(n) {
	if (n == 0) {stop("There is no zeroth prime")}
	i <- 2 #prime candidate
    j <- 0 #current top prime
    k <- 0 #prime counter
	while (k < n) {
		if (is_prime(i)) {
        	j <- i #candidate is prime => store as current top prime
            k <- k + 1 #up the prime counter
        	i <- i + 1 #move on to the next candidate
        } else {
        	i <- i + 1 #move on to the next candidate
        }  
	}
    return(j)
}