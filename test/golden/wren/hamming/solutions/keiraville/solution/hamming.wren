class Hamming {
  static compute(first, second) {
    if (first.count != second.count) {
      Fiber.abort("strands must be of equal length")
    }
    var i = 0
    var result = 0
    while (i < first.count) {
      if (first.codePoints[i] != second.codePoints[i]) {
        result = result + 1
      }
      i = i + 1
    }
    return result
  }
}
