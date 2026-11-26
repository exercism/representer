class CryptoSquare {
  static ciphertext(plaintext) {
    var s = plaintext.bytes
                     .where { |x| x >= 48 && x <= 57 || x >= 97 && x <= 122 && x >= 65 && x <= 97 }
                     .map { |x| String.fromByte(x | 32) }
                     .join()
    var c = s.count.sqrt.ceil
    var a = (0...c).map { [" "] * s.count.sqrt.round }.toList
    for (i in 0...s.count) {
      a[i % c][i / c | 0] = s[i]
    }
    return a.map { |x| x.join() }.join(" ")
  }
}
