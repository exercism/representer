class Number {
  static toRoman(value) {
    return value.toString.bytes.reduce("") { |a, b| a.bytes.map { |x| "CX MD L"[x % 8] }.join() + ",I,II,III,IV,V,VI,VII,VIII,IX".split(",")[b + 48] }
  }
}