// Implementation works for more than two queens as long as 
// each queen has an individual "color".
// As such it could be a basis for solivng the 8-queen-problem.
class QueenAttack {
  construct new(initial) {
    _pieces = { "white": [7,3], "black": [0,3] }
    initial.each { |piece| _pieces[piece.key] = piece.value }
    buildBoard
  }

  static new() { this.new({}) }

  upper(str) {
    var symbol = str[0]
    if (symbol == "w") return "W" 
    if (symbol == "b") return "B" 
    return symbol
  }

  buildBoard {
    _board = (0..7).map { |i| List.filled(8, "_") }.toList
    for (piece in _pieces) {
      if (piece.value.any { |p| p < 0 || p > 7 }) {
        Fiber.abort("Queen must be placed on the board")
      }
      if (_board[piece.value[0]][piece.value[1]] != "_") {
        Fiber.abort("Queens cannot share the same space")
      }
      _board[piece.value[0]][piece.value[1]] = upper(piece.key)
    }    
  }
    
  pieces { _pieces }
  
  white { _pieces["white"] }

  black { _pieces["black"] }

  toString { _board.map { |line| line.join(" ") }.join("\n") }

  canAttack {
    var pieceList = pieces.toList
    while (pieceList.count > 0) {
      var piece = pieceList[0]
      pieceList.removeAt(0)
      if (pieceList.any { |other| canAttack(piece.value, other.value) }) {
        return true
      }
    }
    return false
  }

  canAttack(pos1, pos2) {
    var d = (0..1).map { |i| pos1[i] - pos2[i] }.toList
    return d[0] == 0 || d[1] == 0 ||  d[0].abs == d[1].abs
  }

}
