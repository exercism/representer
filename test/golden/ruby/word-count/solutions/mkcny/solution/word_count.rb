class Phrase
  def initialize(str)
    @str = str
  end

  def word_count
    @str.downcase.scan(/\b[\w']+\b/).tally
  end
end
