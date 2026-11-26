object Series {
  def slices(size: Int, source: String): Seq[Seq[Int]] =
    source.sliding(size).toSeq.filter(slice => slice.map(_.asDigit))
}
