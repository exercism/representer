class Words {
  static count(sentence) {
    var r = {}
    for (x in sentence.map { |x| "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'".contains(x) ? String.fromByte(x.bytes[0] | 32) : " " }.join().split(" ")) {
      if (x != "") {
        if (x[0] == "'" && x[-1] == "'") {
          x = x[1..-2]
        }
        r[x] = (r[x] || 0) + 1
      }
    }
    return r
  }
}
