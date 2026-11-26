{
  limit = $1
  build_sieve(sieve, limit)

  primes = ""
  for (i = 1; i <= limit; i++) {
    if (sieve[i]) {
      if (primes) primes = primes ","
      primes = primes i
    }
  }

  print primes
}

function build_sieve(sieve, limit,    i, ii) {
  clear_array(sieve)

  sieve[2] = 1
  for (i = 3; i <= limit; i += 2) {
    # Skip non-prime numbers that have already been zeroed out
    if (i in sieve) continue

    # Add new prime
    sieve[i] = 1

    # Zero out all multiples of the new prime
    for (ii = i * 3; ii <= limit; ii += i * 2) {
      sieve[ii] = 0
    }
  }
}

function clear_array(array) {
  split("", array)
}