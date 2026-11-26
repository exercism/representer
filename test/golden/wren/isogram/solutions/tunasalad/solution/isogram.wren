var LOWER_A = "a".codePoints[0]
var UPPER_A = "A".codePoints[0]

class Isogram {
  static isIsogram(string) {
    var arr = [false] * 26
    for (x in string) {
      if (between(x,"A","Z")) {
        x = String.fromCodePoint(x.codePoints[0] - UPPER_A + LOWER_A)
      }
      if (between(x,"a","z")) {
        var y = x.codePoints[0] - LOWER_A
        if (arr[y]) return false
        arr[y] = true
      }
    }
    return true
  }
  static between(char, left, right) {
    var c = char.codePoints[0]
    var l = left.codePoints[0]
    var r = right.codePoints[0]
    return (l <= c && c <= r)
  }
}
