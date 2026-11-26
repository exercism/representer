class Darts {
  static score(x,y) {
    var rad = (x.pow(2) + y.pow(2)).sqrt
    if(rad <= 1) return 10
    if(rad <= 5) return 5
    if(rad <= 10) return 1
    return 0
  }
}