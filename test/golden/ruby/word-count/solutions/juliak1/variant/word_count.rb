class Phrase
  def initialize(text)
    @text = text.downcase.scan(/\b[\w']+\b/)
  end

  def word_count
    word_count = Hash.new(1)
    @text.each { |word| word_count[word] += 1 }
    word_count
  end
end

module BookKeeping
  VERSION = 1
end