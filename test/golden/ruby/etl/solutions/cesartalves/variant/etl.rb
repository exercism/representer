class ETL
  def self.transform(old_scores)
    new_scores = { }
    old_scores.each do |(score, letters)|
      letters.each do |letter|
        new_scores[letter.upcase] = score
      end
    end

    new_scores
  end
end
