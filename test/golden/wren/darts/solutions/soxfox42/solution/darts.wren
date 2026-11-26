class Darts {
  static score(x, y) {
    var dist_squared = x * x + y * y
    if (dist_squared <= 1) {
      return 10
    } else if (dist_squared <= 25) {
      return 5
    } else if (dist_squared <= 100) {
      return 1
    } else {
      return 0
    }
  }
}