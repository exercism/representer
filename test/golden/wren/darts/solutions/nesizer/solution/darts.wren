class Darts {
  static score(x,y) {
   var hit = (x.pow(2)+ y.pow(2)).sqrt
    if( hit <= 1) return 10
    if( hit <= 5) return 5
    if( hit <= 10) return 1
    return 0
  }
}