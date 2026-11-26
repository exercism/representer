var PushRun = Fn.new {|length, byte| (length == 0) ? "" : ((length == 1 ? "" : length.toString) + String.fromByte(byte)) }

class RLE {
  static encode(s) {
    var count = 0
    var byte = 0
    var output = ""

    for (b in s.bytes) {
      if (byte == b) {
        count = count - 1
      } else {
        output = output + PushRun.call(count, byte)
        count = 1
        byte = b
      }
    }

    return output + PushRun.call(count, byte)
  }

  static decode(s) {
    var output = ""
    var bs = s.bytes

    var iter = null
    while (iter = s.bytes.iterate(iter)) {
      var b = s.bytes.iteratorValue(iter)
      var len = 0
      while (48 <= b && b <= 57) {
        len = 10 * len + b - 48
        iter = s.bytes.iterate(iter)
        b = s.bytes.iteratorValue(iter)
      }

      output = output +  String.fromByte(b) * (len == 0 ? 1 : len)
    }

    return output
  }
}
