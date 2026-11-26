class QueenAttack {
  construct new() {
    _white = [7,3]
    _black = [0,3]
  }
  construct new(pieces) {
    _white = pieces["white"] || [7,3]
    if (_white[0] < 0 || _white[0] >= 8 || _white[1] < 0 || _white[1] >= 8 ) {
      Fiber.abort("Queen must be placed on the board")
    }
    
    _black = pieces["black"] || [0,3]
    if (_black[0] < 0 || _black[0] >= 8 || _black[1] < 0 || _black[1] >= 8 ) {
      Fiber.abort("Queen must be placed on the board")
    }
    if (_white[0] == _black[0] && _white[1] == _black[1]) {
      Fiber.abort("Queens cannot share the same space")
    }
  }
  white { _white }
  black { _black }

  toString {
    return (0...8).map {|y|
      var c = y == white[0] ? "W" : y == black[0] ? "B" : "_"
      var cx = y == white[0] ? white[1] : y == black[0] ? black[1] : -1
      return (0...8).map {|x| x == cx ? c : "_" }.join(" ")   
    }.join("\n")
  }

  canAttack { white[0] == black[0] ||
    white[1] == black[1] || 
    white[0] - white[1] == black[0] - black[1] ||
    white[0] + white[1] == black[0] + black[1] }
}
