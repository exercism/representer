var LOWER_A = "a".codePoints[0]
var UPPER_A = "A".codePoints[0]
var LOWER_Z = "z".codePoints[0]
var UPPER_Z = "Z".codePoints[0]

class Pangram {
  static isPangram(sentence) {
    var arr = [false] * 26
    for (c in sentence) {
      var a = c.codePoints[0]
      if (LOWER_A <= a && a <= LOWER_Z) arr[a - LOWER_A] = true
      if (UPPER_A <= a && a <= UPPER_Z) arr[a - UPPER_A] = true
    }
    return arr.all {|x| x}
  }
}
