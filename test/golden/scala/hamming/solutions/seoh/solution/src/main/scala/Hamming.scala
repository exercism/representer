

object Hamming {
  def distance(l: String, r: String): Option[Int] =
    if(l.length != r.length) None
    else Some((l.zip(r) map {
      case (x, y) => if(x != y) 1 else 0
    }).sum)
}
