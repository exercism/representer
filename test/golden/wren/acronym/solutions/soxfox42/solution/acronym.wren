import "essentials" for Strings

class Acronym {
  static parse(phrase) {
    return phrase
      .replace("-", " ") // Replace all delimiters with space
      .replace("_", " ")
      .split(" ") // Split on spaces
      .where {|word| word != ""} // Remove empty words
      .map { |word| Strings.upcase(word[0]) } // Take the uppercase first characters
      .join() // Join the sequence into one string
  }
}
