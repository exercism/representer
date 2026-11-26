module Anagram
  def self.find(subject : String, candidates : Array(String)) : Array(String)
    subject_downcase = subject.downcase
    subject_letters = sorted_letters(subject_downcase)
    candidates.select do |candidate|
      candidate_downcase = candidate.downcase
      candidate_downcase != subject_downcase &&
        sorted_letters(candidate_downcase) == subject_letters
    end
  end

  private def self.sorted_letters(word : String) : Array(Char)
    word.chars.sort!
  end
end
