module LanguageList
  # Creates and returns an empty array of strings
  def self.list
    [] of String
  end

  # Adds a language to the end of the list and returns the updated list
  def self.add(list, language)
    list << language
    list
  end

  # Removes the last language from the list and returns the updated list
  def self.remove(list)
    list.pop
    list
  end

  # Returns the language at the specified index
  def self.at(list, index)
    list[index]
  end

  # Parses a comma-separated string of languages and returns an array
  def self.parse(languages)
    languages.split(", ")
  end
end