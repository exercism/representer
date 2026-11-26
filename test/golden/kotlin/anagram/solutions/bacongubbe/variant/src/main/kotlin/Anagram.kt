class Anagram(private val str: String) {
  fun match(anagrams: Collection<String>): Set<String> = anagrams.filter { it.lowercase() != str.lowercase() }
    .map { it.lowercase().toCharArray().sorted() == str.lowercase().toCharArray().sorted() }.toSet()
}
