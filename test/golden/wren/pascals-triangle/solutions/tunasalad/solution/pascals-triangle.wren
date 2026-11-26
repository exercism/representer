class PascalsTriangle {
  static rows(count) {
    if (count <= 0) return []
    var ans = []
    var arr = [1]
    while (count > 0) {
      ans.add(arr)
      var tmp = arr[0..-1]
      tmp.add(0)
      var i = 1
      for (x in arr) {
        tmp[i] = tmp[i] + x
        i = i + 1
      }
      arr = tmp
      count = count - 1
    }
    return ans
  }
}
