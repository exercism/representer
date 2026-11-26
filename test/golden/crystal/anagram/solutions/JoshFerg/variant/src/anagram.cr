module Anagram
  def self.find(subject : String, candidates : Array(String)) : Array(String)
    if !candidates.find { |s| s.upcase == subject.upcase }
       candidates.reject! { |s|
         s.downcase.chars.sort != subject.downcase.chars.sort 
       } 
    elsif candidates.find { |s| s.upcase == subject.upcase } && candidates.size >=1
      candidates.delete(subject)
      candidates.reject! { |s|
        s.downcase.chars.sort != subject.downcase.chars.sort 
      } 
  else
    Array(String).new
    end
  end
end
