object Hamming extends App {

  def distance(dna1: String, dna2: String): Option[Int] = {
    Option(dna1!=null && dna2!=null && dna1.length==dna2.length) match {
      case Some(true) => Option(dna1.toCharArray.zipWithIndex.filter(tuple => dna2(tuple._2)!=tuple._1).size)
      case Some(false) => None
      case None => None
    }
  }

}