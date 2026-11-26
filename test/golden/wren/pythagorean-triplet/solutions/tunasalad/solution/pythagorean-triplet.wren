class PythagoreanTriplet {
  static tripletsWithSum(n) {
    var ans = []
    var a = 3
    while (a*3 < n) {
      var res = null
      var lo = a + 1
      var hi = (n - a - 1) >> 1
      while (lo <= hi) {
        var b = (lo + hi) >> 1
        var c = n - a - b
        var diff = a*a + b*b - c*c
        if (diff < 0) {
          lo = b + 1
        } else if (diff > 0) {
          hi = b - 1
        } else {
          ans.add([a,b,c])
          break
        }
      }
      a = a + 1
    }
    return ans
  }
}
