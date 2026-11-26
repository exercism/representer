class Sieve
  @primes: (limit) ->
    return [] if limit <= 2

    # Initialize a boolean array marking all numbers up to limit as prime (true)
    isPrime = (true for [0..limit])
    isPrime[0] = isPrime[1] = false

    # Sieve of Eratosthenes
    for p in [2..Math.sqrt(limit)] when isPrime[p]
      # Mark multiples of p starting from p*p
      for step in [p * p..limit] by p
        isPrime[step] = false

    # Collect and return all numbers marked as prime
    number for primeMarked, number in isPrime when primeMarked

module.exports = Sieve