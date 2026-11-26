class Anagram
  def initialize(word)
    @word = word.downcase
  end

  def match(anagrams)
    anagrams.select do |anagram|
      anagram.downcase != @word &&
      anagram.downcase.chars.sort == @word.chars.sort
    end
  end
end
