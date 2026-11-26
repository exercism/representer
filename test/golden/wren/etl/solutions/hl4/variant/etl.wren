class Etl {
  static lowercase(s) { String.fromByte(s.bytes[0] - 32) }
  static transform(legacy) {
    var mapping = {}
    for (pair in legacy) {
      for (letter in pair.value) {
        mapping[lowercase(letter)] = pair.key
      }
    }
    return mapping
  }
}
