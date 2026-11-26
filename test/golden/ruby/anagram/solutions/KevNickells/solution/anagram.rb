class Anagram
  def initialize match_word
    @match_word = match_word.downcase
  end

  def match arr
    arr.select do |word|
      word.downcase != @match_word &&
        word.downcase.chars.sort == @match_word.chars.sort
    end
  end
end
