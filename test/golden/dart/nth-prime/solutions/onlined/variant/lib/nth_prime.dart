class NthPrime {
  List<int> _primes = [2, 3, 5, 7, 11];

  int prime(int n) {
    if (n == 0) {
      throw ArgumentError('There is no zeroth prime');
    }
    _generatePrimesUntil(n);
    return _primes[n + 1];
  }

  void _generatePrimesUntil(int n) {
    final start = _primes.last + 2;
    for (int i = start; _primes.length < n; i += 2) {
      if (_primes.every((prime) => (i % prime != 0))) {
        _primes.add(i);
      }
    }
  }
  // Put your code here
}
