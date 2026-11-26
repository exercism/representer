class Triangle {
  // To avoid repetition, all calculation is performed in the constructor.
  construct new(a, b, c) {
    _equilateral = false
    _isosceles = false
    _scalene = false
    
    // Check triangle inequality
    var sides = [a, b, c]
    sides.sort()
    if (sides[2] >= sides[0] + sides[1]) {
      return
    }

    if (a == b && a == c) {
      _equilateral = true
      _isosceles = true
      return
    }

    if (a == b || b == c || c == a) {
      _isosceles = true
      return
    }

    _scalene = true
  }

  isEquilateral { _equilateral }

  isIsosceles { _isosceles }

  isScalene { _scalene }
}
