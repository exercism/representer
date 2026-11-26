class Raindrops {
  static convert(n) {
    var s = ""
    var factor3 = false
    var factor5 = false
    var factor7 = false
    
    if (n % 3 == 0) {
      s = s + "Pling"
      factor3 = true
    }
    if (n % 5 == 0) {
      s = s + "Plang"
      factor5 = true
    }
    if (n % 7 == 0) {
      s = s + "Plong"
      factor7 = true
    } 
    if (!(factor3 || factor5 || factor7)) {
      return n.toString
    }
    return s
  }
}
