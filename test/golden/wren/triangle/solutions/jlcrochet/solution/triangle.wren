class Triangle {
    construct new(a, b, c) {
        _isValid = a > 0 && b > 0 && c > 0 && a + b >= c && a + c >= b && b + c >= a

        _uniqueSides = 0

        if (a != b && a != c) _uniqueSides = _uniqueSides + 1
        if (b != a && b != c) _uniqueSides = _uniqueSides + 1
        if (c != a && c != b) _uniqueSides = _uniqueSides + 1
    }

    isEquilateral { _isValid && _uniqueSides == 0 }

    isIsosceles { _isValid && _uniqueSides <= 2 }

    isScalene { _isValid && _uniqueSides == 3 }
}
