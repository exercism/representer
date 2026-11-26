class Pangram
  def self.pangram?(phrase)
    ('a'..'z').all? { |e| phrase.downcase.include?(e) }
  end
end