class Triangle {
  construct new(a, b, c) {
    _a = a
    _b = b
    _c = c
    _isTriangle = _a + _b > _c && _b + _c > _a && _a + _c > _b
  }

  anyEqual { _a == _b || _b == _c || _a == _c }

  isEquilateral { _isTriangle && _a == _b && _b == _c  }

  isIsosceles { _isTriangle && anyEqual }

  isScalene { _isTriangle && !anyEqual }
}
