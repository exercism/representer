class Triangle {
  construct new(a, b, c) {
    _s = [a, b, c]
    _s.sort()
  }

  isTriangle { _s[0] + _s[1] > _s[2] }
  
  isEquilateral { isTriangle && _s[0] == _s[2] }

  isIsosceles { isTriangle && (_s[0] == _s[1] || _s[1] == _s[2]) }

  isScalene { isTriangle && _s[0] != _s[1] && _s[1] != _s[2] }
}
