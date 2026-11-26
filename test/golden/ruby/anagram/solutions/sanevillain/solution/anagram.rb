class Anagram
  def initialize(word)
    word_downcase = word.downcase

    @word_downcase = word_downcase
    @word_char_counter = char_counter(word_downcase)
  end

  def match(words)
    words.select do |candidate|
      candidate_downcase = candidate.downcase
      candidate_downcase != @word_downcase &&
        char_counter(candidate_downcase).eql?(@word_char_counter)
    end
  end

  private

  def char_counter(string)
    string.chars.each_with_object(Hash.new(0)) { |c, h| h[c] += 1 }
  end
end
