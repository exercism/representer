object Hamming {
  def distance(dnaStrandOne: String, dnaStrandTwo: String): Option[Int] = {
    if (dnaStrandOne.length() != dnaStrandTwo.length()) {
      // throw(new Exception("DNA Strands not of same length"));
      return None;
    }
    var hamming : Int = 0;
    var i = 0;
    for (i <- 0 to dnaStrandOne.length() - 1) {
      if (dnaStrandOne.charAt(i) != dnaStrandTwo.charAt(i)) {
        hamming = hamming + 1;
      }
    }
    return Option(hamming);
  }
}
