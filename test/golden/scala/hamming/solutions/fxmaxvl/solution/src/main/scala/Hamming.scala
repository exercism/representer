object Hamming {
  def distance(dnaStrandOne: String, dnaStrandTwo: String): Option[Int] = {
    (dnaStrandOne.length == dnaStrandTwo.length, dnaStrandOne.zip(dnaStrandTwo)) match {
      case (false, _) => None
      case (_, pairs) => Some(pairs.toList.count(pair => pair._1 != pair._2))
    }
  }
}
