class Triangle {
  construct new(a, b, c) {
    _a = a
    _b = b
    _c = c
  }

  isTriangle {
    if ((_a + _b > _c) && (_b + _c > _a) && (_c + _a > _b)) return true
    return false
  }
  
  isEquilateral {
    if (!isTriangle) return false
    if ((_a == _b && _b == _c) && (_a > 0)) return true
    return false
  }

  isIsosceles {
    if (!isTriangle) return false
    if ((_a == _b) || (_a == _c) || (_b == _c)) return true
    return false
  }

  isScalene {
    if (!isTriangle) return false
    if (!isIsosceles) return true
    return false
  }
}
