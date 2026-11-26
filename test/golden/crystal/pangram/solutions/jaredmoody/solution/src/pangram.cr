module Pangram
  def self.pangram?(sentence)
    sentence = sentence.downcase
    ('a'..'z').all? { |letter| sentence.includes?(letter) }
  end
end
