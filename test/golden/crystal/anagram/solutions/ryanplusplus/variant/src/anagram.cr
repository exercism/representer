class Anagram
  def self.find(word, candidates)
    word = word.downcase
    normalized_word = normalize(word)
    candidates
      .reject { |candidate| candidate.downcase != word }
      .select { |candidate| normalize(candidate) == normalized_word }
  end

  private def self.normalize(word)
    word.downcase.chars.sort.join
  end
end
