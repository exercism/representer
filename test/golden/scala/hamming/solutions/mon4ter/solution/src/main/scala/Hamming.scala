object Hamming {
  def distance(a: String, b: String): Option[Int] = {
    lazy val it = b.iterator
    Some(a).filter(_.length == b.length).map(_.count(_ != it.next))
  }
}