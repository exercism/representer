class Darts {
  static score(x,y) {
    var radius = (x.pow(2) + y.pow(2)).sqrt
    
    if (radius <= 1) return 10
    if (radius <= 5) return 5
    if (radius <= 10) return 1
    
    return 0
  }
}