object AtbashCipher {
  def encode(input: String): String = {
    input
      .toLowerCase
      .replaceAll("[^a-z0-9]","")
      .map(translate)
      .grouped(5)
      .mkString(" ")
  }

  def decode(input: String): String =
    encode(input).replaceAll(" ","")

  val translate: Char => Char = {
    case x if x.isDigit => x
    case x if x.toInt < 110 => (122 + (x.toInt - 97)).toChar
    case x => (97 + (122 - x.toInt)).toChar
  }
}