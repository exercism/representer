object Hamming {
  def distance(s1: String, s2: String): Option[Int] = {
    def fun(ll: List[Char])(t: (Char, Int)) = if (ll(t._2) != t._1) 1 else 0
    if(s1.length != s2.length) None
    else Some(s1.toList.zipWithIndex.map(fun(s2.toList)(_)).sum)
  }
}