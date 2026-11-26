object Series {
  def slices(size: Int, str: String): Seq[Seq[Int]] =
    str.map(_.asDigit).sliding(size).toList
}
