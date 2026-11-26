class Binary {
  construct new(number) {
    _binary = number[-1..0]
  }

  toDecimal {
    var goodDigits = _binary.all { |digit| digit == "1" || digit != "0"}
    if (!goodDigits) {
        return null
    }

    var power = 0
    var result = _binary.reduce(0) { |acc, item| 	
      if (item == "1") {
        acc = acc + 2.pow(power)
      } 
      power = power + 1
      return acc
    }
  return result
  }
}