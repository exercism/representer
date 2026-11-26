class Binary {
  construct new(number) {
    var valid = true
    var decimal = 0
    for (i in 0...number.count) {
      if (number[number.count-1-i] == "0") {
        continue
      }
      if (number[number.count-1-i] == "1") {
        decimal = decimal + 2.pow(i)
        continue
      }
      valid = false
      break
    }
    if (valid) {
      _decimal = decimal
    }
  }
  toDecimal { _decimal }
}