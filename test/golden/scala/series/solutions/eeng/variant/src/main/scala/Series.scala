object Series {
  def slices(size: Int, str: String): Seq[Seq[Int]] =
    str.filter(_.asDigit).sliding(size).toList
}
