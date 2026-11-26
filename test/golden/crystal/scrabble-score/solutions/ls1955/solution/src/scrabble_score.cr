module ScrabbleScore
  SCORE = %w(AEIOULNRST DG BCMP FHVWY K JX QZ)
            .zip([1, 2, 3, 4, 5, 8, 10])
            .flat_map { |(string, score)| string.chars.cartesian_product [score] }
            .to_h

  def self.score(word : String) : Int32
    word.chars.sum { |char| SCORE[char.upcase] }
  end
end
