class Triangle {
  construct new(a, b, c) {
    _val = a > 0 && b > 0 && c > 0 && a + b > c && a + c > b && b + c > a
    _equ = _val && a == b && a == c
    _iso = _val && (a == b || a == c || b == c)
    _sca = _val && !_equ && !_iso
  }

  isEquilateral { _equ }

  isIsosceles { _iso }

  isScalene { _sca }
}
