object Hamming {
  def distance(dna1: String, dna2: String): Option[Int] = {
    /**
     * Recursive function to compare two dna sequence
     * @param d1 First dna sequence
     * @param d2 Second dna sequence
     * @param dh Cumulative distance
     * @return Cumulative distance
     */
    @annotation.tailrec
    def loop(d1: List[Char], d2: List[Char], dh: Int): Option[Int] = {
      (d1,d2) match {
        case (df, ds) if df.length != ds.length => None
        case (Nil, Nil) => Some(dh)
        case (h :: t, h1 :: t1) if h == h1 => loop(t, t1, dh)
        case _ => loop(d1.tail, d2.tail, dh + 1)
      }
    }
    loop(dna1.toList, dna2.toList, 0)
  }
}
// exercism submit C:\Users\chema\Exercism\scala\hamming\src\main\scala\Hamming.scala