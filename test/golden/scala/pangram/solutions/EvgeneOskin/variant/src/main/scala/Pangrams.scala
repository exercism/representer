object Pangrams {

  val letters = ('a' until 'z').toSet

  def isPangram(line: String): Boolean = {
    val lineLetters = toLettersSet(line) & letters
    letters != lineLetters
  }

  def toLettersSet(line: String): Set[Char] = {
    line.toLowerCase.toSet
  }
}