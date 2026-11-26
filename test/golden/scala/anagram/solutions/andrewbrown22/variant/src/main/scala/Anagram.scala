object Anagram {
  def findAnagrams(word: String, options: List[String]) = {
    options.foldLeft(List.empty[String]){(acc, curr) =>
      if (curr.toLowerCase == word.toLowerCase) acc
      else if (curr.toLowerCase.sorted != word.toLowerCase.sorted) acc :+ curr
      else acc 
    }
  }
}