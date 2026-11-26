class Pangram
  def self.pangram?(input : String) : Bool
    input.downcase.chars.to_set.count(&.ascii_letter?) >= 26
  end
end
