class Pangram
  def self.pangram?(input : String) : Bool
    alphabet = "abcdefghijklmnopqrstuvwxyz"
    lower_case_input = input.downcase
    alphabet.chars.all? {|char| lower_case_input.includes?(char)}
  end
end
