object CryptoSquare {

  def ciphertext(input: String) = {
    val normalized = input.filter(_.isLetterOrDigit).toLowerCase
    val columns = math.ceil(math.sqrt(normalized.length)).intValue

    normalized
      .grouped(columns)
      .map(_.padTo(columns, ' '))
      .toSeq
      .transpose
      .filter(_.mkString)
      .mkString(" ")
  }
}