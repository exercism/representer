class Number {
  static isArmstrong(n) {
    var num = n
    var len = (n.log / 10.log).floor + 1
    var sum = 0
    while (num > 0) {
      var digit = num % 10
      sum = sum + digit.pow(len)
      num = (num / 10).truncate
    }
    return n == sum
  }
}