object SpiralMatrix {
  def spiralMatrix(size: Int): List[List[Int]] = {
    if (size <= 0) Nil
    else {
      val matrix = Array.ofDim[Int](size, size)
      var top = 0
      var bottom = size - 1
      var left = 0
      var right = size - 1
      var value = 1

      // Direct sequential memory fills inside quick primitive while-loops
      while (value <= size * size) {
        // 1. Sweep Left to Right across top row
        var c = left
        while (c < right) {
          matrix(top)(c) = value
          value += 1
          c += 1
        }
        top += 1

        // 2. Sweep Top to Bottom down rightmost column
        var r = top
        while (r <= bottom) {
          matrix(r)(right) = value
          value += 1
          r += 1
        }
        right -= 1

        // 3. Sweep Right to Left across bottom row (if rows remain)
        if (top <= bottom) {
          c = right
          while (c >= left) {
            matrix(bottom)(c) = value
            value += 1
            c -= 1
          }
          bottom -= 1
        }

        // 4. Sweep Bottom to Top up leftmost column (if columns remain)
        if (left <= right) {
          r = bottom
          while (r >= top) {
            matrix(r)(left) = value
            value += 1
            r -= 1
          }
          left += 1
        }
      }

      // Single-pass list generation bypassing intermediate arrays
      List.tabulate(size)(r => matrix(r).toList)
    }
  }
}