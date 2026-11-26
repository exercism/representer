object Hamming {
  def distance(strand1: String, strand2: String): Option[Int] = {
    if (strand1.length != strand2.length) { None }
    else {
      var count: Int = 0
      for (i <- 0 until strand1.length) {
        if (strand1(i) != strand2(i))
          count += 1
      }
      Some(count)
    }}  
}