class ParallelLetterFrequency {
  construct new(inputs) {
    _inputs = inputs
  }

  calculateFrequencies() {
    var o = {}
    _inputs.map { |x| Fiber.new {
      for (c in x.bytes) {
        if (c >= 65 && c <= 90) c = c - 32
        if (c >= 97 && c <= 122) {
          o[String.fromByte(c)] = (o[String.fromByte(c)] || 0) + 1
        }
      }
    } }.toList.each { |x| x.call() }
    return o
  }
}
