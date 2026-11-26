class Diamond {
  static rows(letter) {
    if (letter.bytes.count != 1) Fiber.abort("Expected one letter")

    var a = "A".bytes[0]
    var n = letter.bytes[0] - a + 1
    if (n < 1 || n > 26) Fiber.abort("Expected an uppercase letter")

    var w = n * 2 - 1
    var diamond = List.filled(w, "")
    for (i in 0..n - 1) {
      var c = String.fromByte(a + i)
      var s = i == 0 ? c : c + " " * (i * 2 - 1) + c
      var around = " " * (n - i - 1)
      diamond[i] = diamond[w - i - 1] = around + s + around
    }
    return diamond
  }
}