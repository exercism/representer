case class WordCount(word: String) {
  val wordCharacters = """(\W*)([a-z0-9\']*[a-z0-9])(\W*)""".r
  def countWords: Map[String, Int] = {
    word
      .replace(",", " ")
      .split(" ")
      .toList
      .map(word => word.toLowerCase().trim())
      .map(word => word match { 
        case wordCharacters(_,w,_) => w 
        case _ => "" 
      }
      )
      .filter(word => !word.isEmpty())
      .foldLeft(Map[String,Int]()){
        (m, word) =>( m + (word -> (m.getOrElse(word,0) + 1)) ) 
      }
  }
}
