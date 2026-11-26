class Year {
  static isdiv(n, p) { n % p == 0 }
  static isLeap(n) {
    return (!isdiv(n, 100) || isdiv(n, 400)) && isdiv(n, 4)
  }
}
