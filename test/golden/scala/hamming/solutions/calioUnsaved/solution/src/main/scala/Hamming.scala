object Hamming{
  def distance(dna1: String, dna2: String): Option[Int] = {
    val hammingNumber = dna1.zip(dna2).count(e => e._1 != e._2)

    if(dna1.length == dna2.length) Option(hammingNumber) else Option.empty
  }
}