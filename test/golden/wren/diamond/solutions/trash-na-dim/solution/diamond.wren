class Diamond {
  static rows(letter) {
    var res = []
    var max = letter.codePoints[0] - "A".codePoints[0]
    for (i in 0..max) {
      var curr = ""
      var letter = String.fromCodePoint(i + "A".codePoints[0])
      var padding = " " * (max - i)
      if (i > 0) {
        res.add(padding + letter + " " * (2 * i - 1) + letter + padding)
      } else {
        res.add(padding + letter + padding)
      }
    }

    if (max > 0) {
      for (i in (max - 1)..0) {
        var curr = ""
        var letter = String.fromCodePoint(i + "A".codePoints[0])
        var padding = " " * (max - i)
        if (i > 0) {
          res.add(padding + letter + " " * (2 * i - 1) + letter + padding)
        } else {
          res.add(padding + letter + padding)
        }
      }
    }
    
    
    return res
  }
}