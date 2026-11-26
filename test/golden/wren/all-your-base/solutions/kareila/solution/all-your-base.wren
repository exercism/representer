class AllYourBase {
  static rebase(inputBase, digits, outputBase) {
    if (inputBase < 2) { Fiber.abort("input base must be >= 2") }
    if (outputBase < 2) { Fiber.abort("output base must be >= 2") }
    if (digits.any {|d| d < 0 || d >= inputBase}) { 
      Fiber.abort("all digits must satisfy 0 <= d < input base") 
    }
    var intDigits = digits.reduce(0) {|acc, d| (acc * inputBase) + d}
    var output = []
    while (intDigits != 0) {
      output.insert(0, intDigits % outputBase)
      intDigits = (intDigits / outputBase).floor
    }
    return output.isEmpty ? [0] : output
  }
}