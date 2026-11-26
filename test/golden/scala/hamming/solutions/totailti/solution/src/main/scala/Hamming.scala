object Hamming {
  @scala.annotation.tailrec
  def _distance(x: String, y: String, acc: Int = 0): Int = (x, y) match {
    case (a, b) if a.isEmpty => acc
    case (a, b) if a.head == b.head => _distance(a.tail, b.tail, acc)
    case _ => _distance(x.tail, y.tail, acc + 1)
  }

  def distance(x: String, y: String): Option[Int] = (x, y) match {
    case (a, b) if a.length != b.length => None
    case _ => Some(_distance(x, y, 0))
  }

}