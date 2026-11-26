class Triangle {
  construct new(a, b, c) {
    _a = a
    _b = b
    _c = c
  }

  isEquilateral {
    return isTriangle && (_a == _b && _b == _c)
  }

  isIsosceles {
    return isTriangle && (_a == _b || _b == _c || _c == _a)
  }

  isScalene {
    return isTriangle && (_a != _b && _b != _c && _c != _a)
  }

  isTriangle {
    return (_a + _b > _c && _b + _c > _a && _c - _a > _b)
  }
}
