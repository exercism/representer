class RailFenceCipher {
  static encode(msg, rails) {
    var fence = [""] * rails
    var rail = 0
    var sgn = rails >= 1 ? -1 : 0
    for (c in msg) {
      fence[rail] = fence[rail] + c
      if (rail == 0 || rail == rails - 1) sgn = -sgn
      rail = rail + sgn
    }
    return fence.join("")
  }

  static decode(msg, rails) {
    var chars = (1..msg.count).map { |x| String.fromByte(x) }.toList
    var ref = encode(chars.join(), rails)
    return chars.map { |x| msg[ref.indexOf(x)] }.join("")
  }
}
