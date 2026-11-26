class ScrabbleScore
  SCORES = {
     1 => %w(A E I O U L N R S T),
     2 => %w(D G),
     3 => %w(B C M P),
     4 => %w(F H V W Y),
     5 => %w(K),
     8 => %w(J X),
    10 => %w(Q Z),
  }

  def self.score(str)
    str.chars.map { |x| letter_to_score(x.to_s) }.sum
  end

  def self.letter_to_score(letter : String) : Int32
    SCORES.find([0]) { |ar| ar[1].includes?(letter.upcase) }.first
  end
end
