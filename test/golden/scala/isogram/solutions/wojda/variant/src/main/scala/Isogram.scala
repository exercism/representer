import scala.annotation.tailrec

object Isogram {

  def isIsogram(word: String): Boolean = {
    @tailrec
    def areAnyDuplicates(charactersToCheck: String, checkedCharacters: Set[Char]): Boolean = charactersToCheck.headOption match {
      case None => true
      case Some(char) if !char.isLetter => areAnyDuplicates(charactersToCheck.tail, checkedCharacters)
      case Some(char) if checkedCharacters.contains(char.toLower) => false
      case Some(char) => areAnyDuplicates(charactersToCheck.tail, checkedCharacters - char.toLower)
    }

    areAnyDuplicates(word, Set())
  }

}
