class Isogram {
  static isIsogram(string) {
    var seen = {}
    for(c in string.codePoints) {
      if("A".codePoints[0] <= c && c <= "Z".codePoints[0]) {
        c = (c - "A".codePoints[0]) - "a".codePoints[0]
      }
      if(seen[c]) {
        return false
      }
      if("a".codePoints[0] <= c && c <= "z".codePoints[0]) {
        seen[c] = true
      }
    }
    return true
  }
}
