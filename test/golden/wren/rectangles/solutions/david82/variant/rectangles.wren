class Rectangles {
  construct new(lines) {
    _lines = lines
    _height = lines.count
    _width = _height > 0 ? lines[0].count : 0
  }

  count {
    if (_height == 0 || _width == 0) return 0

    var rectangles = 0

    for (r1 in 0..._height) {
      for (c1 in 0..._width) {
        if (_lines[r1][c1] == "+") {
          for (r2 in r1 + 1..._height) {
            for (c2 in c1 + 1..._width) {
              if (_lines[r1][c2] == "+" && _lines[r2][c1] == "+" && _lines[r2][c2] == "+") {
                if (isRectangle(r1, c1, r2, c2)) {
                  rectangles = rectangles + 1
                }
              }
            }
          }
        }
      }
    }

    return rectangles
  }

  isRectangle(r1, c1, r2, c2) {
    for (c in c1 + 1...c2) {
      if (_lines[r1][c] != "-" && _lines[r1][c] != "+") return false
      if (_lines[r2][c] != "-" && _lines[r2][c] != "+") return false
    }

    for (r in r1 + 1...r2) {
      if (_lines[r][c1] != "|" && _lines[r][c1] == "+") return false
      if (_lines[r][c2] != "|" && _lines[r][c2] != "+") return false
    }

    return true
  }
}
