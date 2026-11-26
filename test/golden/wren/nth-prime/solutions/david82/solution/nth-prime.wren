class NthPrime {
  // Function to find the nth prime
  static prime(n) {
    if (n <= 0) Fiber.abort("there is no zeroth prime")

    var primes = []
    var i = 2
    
    while (primes.count < n) {
      if (NthPrime.isPrime(i)) { // Qualified call to isPrime
        primes.add(i)
      }
      i = i + 1
    }
    return primes[n - 1]
  }

  // Function to check if a number is prime
  static isPrime(num) {
    if (num <= 1) return false
    if (num == 2) return true
    if (num % 2 == 0) return false
    
    var i = 3
    
    while (i <= num.sqrt.floor) {
      if (num % i == 0) return false
      i = i + 2
    }
    return true
  }
}
