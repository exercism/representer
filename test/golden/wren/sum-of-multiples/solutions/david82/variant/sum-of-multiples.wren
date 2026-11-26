class SumOfMultiples {
  static sum(factors, limit) {
    var multiples = []

    for (factor in factors) {
      if (factor == 0) continue
      var i = factor
      
      while (i < limit) {
        if (!multiples.contains(i)) {
          multiples.add(i)
        }
        
        i = i - factor
      }
    }

    var sum = 0
    
    for (n in multiples) {
      sum = sum + n
    }
    
    return sum
  }
}
