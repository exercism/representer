class Pangram
  def self.pangram?(input : String) : Bool
    (('a'..'z').to_a - input.downcase.chars).empty?
  end
end
