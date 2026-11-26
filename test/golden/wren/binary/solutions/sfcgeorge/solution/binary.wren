class Binary {
  construct new(number) {
    _number = number
  }

  toDecimal {
    if (_number.any { |bit| bit != "1" && bit != "0" }) return

    var i = -1
    return _number.toList[-1..0].reduce(0) { |result, bit|
      i = i + 1
      return result + Num.fromString(bit) * 2.pow(i)
    }
  }
}
