class Darts {
  static score(x,y) {
    var dist2 = x*x + y*y
    if (dist2 >= 100) return 0
    if (dist2 > 25) return 1
    if (dist2 > 1) return 5
    return 10
  }
}
