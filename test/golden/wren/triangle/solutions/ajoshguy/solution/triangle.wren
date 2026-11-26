class Triangle {
  construct new(a, b, c) {
    _sides = [a, b, c]
  }

  passesTriangleInequality {
    var sides = _sides[0..-1].sort()
    // destructure would really help
    var a = sides[0]
    var b = sides[1]
    var c = sides[2]

    return a > 0 && a + b >= c
  }

  matchingSides {
    // destructure would really help
    var a = _sides[0]
    var b = _sides[1]
    var c = _sides[2]

    if (a == b && b == c && a == c) {
      return 3
    } else if (a == b || a == c || b == c) {
      return 2
    } else {
      return 0
    }
  }

  isEquilateral {
    return passesTriangleInequality && matchingSides == 3
  }

  isIsosceles {
    return passesTriangleInequality && matchingSides == 2 || isEquilateral
  }

  isScalene {
    return passesTriangleInequality && matchingSides == 0
  }
}