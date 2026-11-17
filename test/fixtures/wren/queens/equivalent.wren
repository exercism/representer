class Grid {
  static length { 0...8 }
  static sameCell(p, q) { p.join(",") == q.join(",") }
  static contains(p) { length.contains(p[0]) && length.contains(p[1]) }
}

var START = { "white": [7, 3], "black": [0, 3] }
class Queens {
  construct new(pieces) {
    _w = pieces["white"] || START["white"]
    _b = pieces["black"] || START["black"]
    check()
  }
  static new() { Queens.new({}) }
  w { _w }
  b { _b }
  check() {
    checkOne(w)
    checkOne(b)
    if (Grid.sameCell(w, b)) Fiber.abort("Queens cannot share the same space")
  }
  checkOne(piece) {
    if (!Grid.contains(piece)) {
      Fiber.abort("Queen must be placed on the board")
    }
  }
  at(sq) {
    if (Grid.sameCell(sq, w)) return "W"
    if (Grid.sameCell(sq, b)) return "B"
    return "_"
  }
  toString {
    var out = ""
    for (r in Grid.length) {
      for (c in Grid.length) {
        out = out + at([r, c]) + " "
      }
      out = out.trim() + "\n"
    }
    return out.trim()
  }

  sameRow { w[0] == b[0] }
  sameColumn { w[1] == b[1] }
  sameDiagonal { (b[0] - w[0]).abs == (b[1] - w[1]).abs }
  canAttack { sameRow || sameColumn || sameDiagonal }
}
