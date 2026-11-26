object Hamming {
  
  def distance(dnaStrandOne: String, dnaStrandTwo: String): Option[Int] = {
    if (dnaStrandOne.length == dnaStrandTwo.length) {
      Some(dnaStrandOne.zip(dnaStrandTwo).count(value => value._1 != value._2))
    } else {
      None
    }
  }
}
