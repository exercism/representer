class QueenAttack {
  white { _white }
  black { _black }

  construct new() {
    init({})
  }

  construct new(pieces) {
    init(pieces)
  }

  init(pieces) {    
    _white = pieces["white"]
    _black = pieces["black"]

    if (_white is Null) { _white = [7,3] }
    if (_black is Null) { _black = [0,3] }
    
    if (!(valid(_white) && valid(_black))) {
      Fiber.abort("Queen must be placed on the board")
    }

    if (_white[0] == _black[0] && _white[1] == _black[1]) {
      Fiber.abort("Queens cannot share the same space")
    }
  }

  toString {
    var grid = (0...8).map {|j| (0...8).map {|i| "_"}.toList}.toList
    grid[_white[0]][_white[1]] = "W"
    grid[_black[0]][_black[1]] = "B"
    return grid.map {|row| row.join(" ")}.join("\n")
  }

  canAttack {
    return _white[0] == _black[0] ||
      _white[1] == _black[1] ||
      _white[1] - _white[0] == _black[1] - _black[0] ||
      _white[1] + _white[0] == _black[1] + _black[0]
  }

  valid(piece) {
    return piece[0] >= 0 && piece[0] < 8 &&
      piece[1] >= 0 && piece[1] < 8
  }
}
