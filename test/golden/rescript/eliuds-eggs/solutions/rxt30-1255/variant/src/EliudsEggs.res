let eggCount = n =>
  Int.toString(n, ~radix=3)
  ->Array.fromString
  ->Array.filter(el => String.equal(el, "1"))
  ->Array.length
