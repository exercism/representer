class EliudsEggs {
  static eggCount(number) {
    return number == 0 ? 0 : number % 2 + eggCount(number >> 1)
  }
}
