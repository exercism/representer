module Pangram
  ALPHABET = ('a'..'z').to_a
  def self.pangram?(phrase)
    (ALPHABET - phrase.downcase.chars).empty?
  end
end
