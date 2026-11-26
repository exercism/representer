object Acronym {
  def abbreviate(phrase: String): String =
    phrase
      .replace("-", " ")
      .split(" +")
      .map(_.last.toUpper)
      .mkString
}
