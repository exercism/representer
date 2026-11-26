var UPPER_A = "A".codePoints[0]

class Diamond {
  static rows(letter) {
    var n = letter.codePoints[0] - UPPER_A + 1
    if (n < 1 || n > 26) Fiber.abort("?")
    var last = 2 * n - 2
    var center = n - 1
    var ans = []
    for (r in 0..last) {
      var dr = (center - r).abs
      var res = []
      for (c in 0..2*n-2) {
        var dc = (center - c).abs
        var x = " "
        if (dr + dc == center) x = String.fromCodePoint(UPPER_A + r.min(last - r))
        res.add(x)
      }
      ans.add(res.join())
    }
    return ans
  }
}
