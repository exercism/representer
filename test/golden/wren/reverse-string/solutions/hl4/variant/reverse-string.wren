class StringUtil {
  static reverse(string) {
    if (string.isEmpty) return string
    return string[-1..1]
  }
}
