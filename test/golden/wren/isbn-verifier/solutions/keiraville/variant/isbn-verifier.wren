class ISBN {
  construct new(s) {
    _s = s
  }

  isValid {
    var index = 0
    var weight = 10
    var total = 0
    var weightedTotal = 0
    for (ch in _s.bytes) {
      if (ch == 45) {
        continue
      }
      var digit = ch - 48
      if (digit < 0 || digit > 9) {
        if (weight != 1 || ch != 88) {
          return false
        }
        digit = 10
      }

      total = total + digit
      weightedTotal = weightedTotal + total
      weight = weight - 1
    }
    return weight != 0 && weightedTotal % 11 == 0
  }  
}