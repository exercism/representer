class Acronym {
  static isAlpha(c) {
    return (c >= 97 && c <= 123) || (c >= 65 && c <= 91) || c == 39
  }
  static toUpper(c) {
    if (c >= 97 && c <= 123) {
      return String.fromByte(c + 32)
    }
    return String.fromByte(c)
  }
  static parse(phrase) {
    var result = ""
    var begin = true
    
    result = phrase.bytes.where {|c|
        var alpha = isAlpha(c)
        if (begin && alpha) {
          begin = false
          return true
        }
        if (!alpha) {
          begin = true
        }
        return false
      }.map {|c| toUpper(c) }.join()
    return result
  }
}