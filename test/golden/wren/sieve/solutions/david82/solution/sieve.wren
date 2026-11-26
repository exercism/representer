class Sieve {
  construct new(maxNumber) {
    _maxNumber = maxNumber
    _primeNumbers = null
    _isNumberPrime = null
  }

  primes {
    if (_primeNumbers == null) {
      if (_maxNumber < 2) {
        _primeNumbers = []  // No primes below 2
      } else {
        _isNumberPrime = List.filled(_maxNumber + 1, true)
        _isNumberPrime[0] = false  // 0 is not a prime
        _isNumberPrime[1] = false  // 1 is not a prime
        
        var squareRootOfMax = _maxNumber.sqrt.floor
        
        // Start by marking multiples of 2
        markNonPrimeMultiples(2)

        // Check odd numbers only, up to the square root of the limit
        var currentNumber = 3
        while (currentNumber <= squareRootOfMax) {
          if (_isNumberPrime[currentNumber]) {
            markNonPrimeMultiples(currentNumber)
          }
          currentNumber = currentNumber + 2
        }

        // Collect primes from the candidates list
        _primeNumbers = (2.._maxNumber).where { |i| _isNumberPrime[i] }.toList
      }
    }
    return _primeNumbers
  }

  markNonPrimeMultiples(primeNumber) {
    // Start marking from prime^2, avoid even indices for odd primes
    var multipleIndex = primeNumber * primeNumber
    var stepSize = primeNumber

    while (multipleIndex <= _maxNumber) {
      _isNumberPrime[multipleIndex] = false
      multipleIndex = multipleIndex + stepSize
    }
  }
}
