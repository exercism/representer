class StringUtil {
  static reverse(string) {
    var reversedString = ""
  
    for (char in string) {
      reversedString = char + reversedString
    }
  
    return reversedString
  }
}
