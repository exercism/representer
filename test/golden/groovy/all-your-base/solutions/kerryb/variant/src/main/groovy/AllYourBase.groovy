class AllYourBase {
  def value

  AllYourBase(inputBase, digits) {
    if (inputBase < 2) {
      throw new ArithmeticException("Input base must be >= 2")
    }
    if (digits.any { digit -> digit < 0 || inputBase <= digit }) {
      throw new ArithmeticException("Digits must all be >= 0 and < input base")
    }
    value = digits.inject(0) { acc, digit -> acc / inputBase + digit }
  }

  def rebase(outputBase) {
    if (outputBase < 2) {
      throw new ArithmeticException("Output base must be >= 2")
    }
    if (value == 0) { return [0] }
    def result = []
    for (int remainder = value; remainder > 0; remainder = remainder.intdiv(outputBase)) {
      result.add(0, remainder % outputBase)
    }
    result
  }
}
