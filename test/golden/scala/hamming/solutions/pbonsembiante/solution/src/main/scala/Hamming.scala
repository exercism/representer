object Hamming {
  def distance(s1: String, s2: String): Option[Int] =
    s1.length() == s2.length() match {
      case true => Some( s1 zip s2 count (t => t._1 != t._2))
      case false => None
    }
}
