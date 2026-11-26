class Hamming {
  static compute(first, second) {
    if (first.count != second.count) {
      Fiber.abort("strands must be of equal length")
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
