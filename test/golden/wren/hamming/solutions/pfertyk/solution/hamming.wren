class Hamming {
  static compute(first, second) {
    if (first.count != second.count) {
      Fiber.abort("strands must be of equal length")
    }
    if (first.count == 0) {
      return 0
    }
    var diff = 0
    for (i in 0...first.count) {
      if (first[i] != second[i]) {
        diff = diff + 1
      }
    }
    return diff
  }
}
