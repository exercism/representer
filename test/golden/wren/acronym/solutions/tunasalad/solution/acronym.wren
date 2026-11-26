class Acronym {
  static parse(phrase) {
    return (phrase
      .map {|x| x == "-" ? " " : x}
      .where {|x| between(x,"a","z") || between(x,"A","Z") || x == " "}
      .join()
      .split(" ")
      .where {|x| !x.isEmpty}
      .map {|x|
        var c = x.codePoints[0]
        if (between(x,"a","z")) c = c - 32
        return String.fromCodePoint(c)
      }
      .join())
  }

  static between(char, left, right) {
    var c = char.codePoints[0]
    var l = left.codePoints[0]
    var r = right.codePoints[0]
    return (l <= c && c <= r)
  }
}
