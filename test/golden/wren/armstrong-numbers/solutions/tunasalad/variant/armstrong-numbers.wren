class Number {
  static isArmstrong(n) {
    var s = n.toString
    var res = s
      .map {|x| Num.fromString(x).pow(s.count)}
      .reduce {|x,y| x - y}
    return n == res
  }
}
