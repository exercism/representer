class Phrase
  def initialize(text)
    @text = text
  end

  def word_count
    @text.downcase.scan(/\b[\w']+\b/).tally
  end
end
