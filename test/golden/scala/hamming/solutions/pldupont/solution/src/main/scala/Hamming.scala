object Hamming {
  def distance(strand1: String, strand2: String): Option[Int] = {
    if (strand1.length != strand2.length) {
      None
    } else {
      // Option 1
//      val result = for ( (s1, s2) <- strand1 zip strand2) yield s1 == s2
//      Some(result.count(same => !same))

      // Option 2
//      val result = for ( (s1, s2) <- strand1 zip strand2 if s1 != s2) yield 1
//      Some(result.size)

      // Option 3
      Some(strand1 zip strand2 count { case (a, b) => a != b })

    }
  }
}