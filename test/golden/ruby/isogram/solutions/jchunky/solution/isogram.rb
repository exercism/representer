class Isogram
  def self.isogram?(phrase)
    letters = phrase.downcase.scan(/\w/)
    letters == letters.uniq
  end
end
