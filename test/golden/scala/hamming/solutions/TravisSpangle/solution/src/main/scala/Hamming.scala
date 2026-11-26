object Hamming {
  def distance(strand1:String, strand2:String): Option[Int] = {
    if (strand1.length() == strand2.length()) {
      Some( strand1.zip(strand2).count( e => e._1 != e._2 ) )
    }else{
      None
    }
  }
}
