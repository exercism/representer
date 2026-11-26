class Darts {
  static score(x,y) {
    var dist = (x*x + y*y).sqrt
    if (dist <= 1) {
      return 10
    } else if (dist <= 5) {
      return 5
    } else if (dist <= 10) {
      return 1
    } else {
      return 0
    }
  }
}