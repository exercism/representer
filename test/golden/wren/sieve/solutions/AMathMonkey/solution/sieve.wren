class Sieve {
  construct new(limit) {
    _markers = List.filled(limit + 1, true)
    for (i in 2 ... _markers.count) {
      if (!_markers[i]) continue
      var i1 = i + i
      while (i1 < _markers.count) {
        _markers[i1] = false
        i1 = i1 + i
      }
    }
  }

  primes {
    var result = List.new()
    for (i in 2 ... _markers.count) {
      if (_markers[i]) result.add(i)
    }
    return result
  }
}
