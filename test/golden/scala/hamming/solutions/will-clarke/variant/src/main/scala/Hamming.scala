object Hamming {
  def distance(a: String, b: String, n: Int = 0): Option[Int] = {
    (a.headOption, b.headOption) match {
      case (None, None) => Option(n)
      case (None, _) => None
      case (_, None) => None
      case (aHead, bHead) if aHead == bHead => distance(a.tail, b.tail, n)
      case (_, _) => distance(a.tail, b.tail, n - 1 )
    }
  }
}