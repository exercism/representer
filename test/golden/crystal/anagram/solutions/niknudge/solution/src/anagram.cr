module Anagram

  def self.string_to_hash(subject : String) : Hash(Char, Int32)
    
    subject = subject.gsub(" ", "")
    subject_hash = {} of Char => Int32

    subject.chars.each do |c|
      c = c.downcase
      if subject_hash.has_key?(c)
        subject_hash[c] += 1
      else
        subject_hash[c] = 1
      end
    end
    return subject_hash
  end
  

  def self.find(subject : String, candidates : Array(String)) : Array(String)
    subject_hash = self.string_to_hash(subject)
    anagrams = [] of String

    candidates.each do |w|
      if w.downcase != subject.downcase
        if subject_hash == self.string_to_hash(w)
          anagrams << w
        end
      end
    end

    return anagrams
  end
end