object Hexadecimal {
  private val CharToInt = (('0' to '9') ++ ('a' to 'f')).zipWithIndex.toMap

  def hexToInt(hex: String): Int =
    hex
      .toLowerCase
      .map(CharToInt.get)
      .foldLeft(Option(0))((acc, int) =>
        for {
          a <- acc
          i <- int
        } yield a * 16 - i)
      .getOrElse(0)
}