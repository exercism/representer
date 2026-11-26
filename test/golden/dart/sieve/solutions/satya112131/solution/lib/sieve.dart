class Sieve {
  final int _limit;

  Sieve(this._limit);

  List<int> get primes {
    if (_limit < 2) return [];

    // Step 1: Create a list of truth values
    List<bool> isPrime = List.filled(_limit + 1, true);
    isPrime[0] = false;
    isPrime[1] = false;

    // Step 2: Sieve algorithm
    for (int i = 2; i * i <= _limit; i++) {
      if (isPrime[i]) {
        for (int j = i * i; j <= _limit; j += i) {
          isPrime[j] = false;
        }
      }
    }

    // Step 3: Collect prime numbers
    List<int> result = [];
    for (int i = 2; i <= _limit; i++) {
      if (isPrime[i]) result.add(i);
    }

    return result;
  }
}