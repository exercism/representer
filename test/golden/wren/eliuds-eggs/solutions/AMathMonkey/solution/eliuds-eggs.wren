class EliudsEggs {
  static eggCount(number) {
    var result = 0
    while (number > 0) {
      result = result + (number & 1)
      number = number >> 1
    }
    return result
  }
}
