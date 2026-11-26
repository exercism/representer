object Hamming {
  def distance(a: String, b: String) = {
    if (a.size != b.size)
      None
    else
      Some(a.zip(b).count(p => p._1 != p._2))
  }
}
