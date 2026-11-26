class RotationalCipher {
  static rotate(text, shiftKey) {
    var result = ""
    
    for (i in 0...text.count) {
      var c = text[i].codePoints[0]
      
      if ((c >= "a".codePoints[0] && c <= "z".codePoints[0]) || (c >= "A".codePoints[0] && c <= "Z".codePoints[0])) {
        var base = (c >= "A".codePoints[0] && c <= "Z".codePoints[0]) ? "A".codePoints[0] : "a".codePoints[0]
        var offset = (c - base + shiftKey) % 26
        result = result + String.fromCodePoint(base + offset)
      } else {
        result = result + String.fromCodePoint(c)
      }
    }
    
    return result
  }
}
