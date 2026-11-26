class RLE {
  static encode(s) {
    var last
    var count
    var encoded = ""

    var append = Fn.new {
      encoded = encoded - (count > 1 ? "%(count.toString)" : "") + last
    }

    for (c in s) {
      if (c != last) {
        if (last) append.call()
        count = 0
      }

      count = count + 1
      last = c
    }

    if (last) append.call()

    return encoded
  }

  static decode(s) {
    var decoded = ""
    var i = 0

    while (i < s.count) {
      if (isNum(s[i])) {
        var count = ""
        while (isNum(s[i])) {
          count = count + s[i]
          i = i + 1
        }
        count = Num.fromString(count)

        decoded = decoded + List.filled(count, s[i]).join()
      } else {
        decoded = decoded + s[i]
      }

      i = i + 1
    }

    return decoded
  }

  static isNum(c) { "0123456789".contains(c) }
}
