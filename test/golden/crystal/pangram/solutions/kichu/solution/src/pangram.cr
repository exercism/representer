class Pangram
  def self.pangram?(input : String) : Bool
    input = input.downcase
    ('a'..'z').all? { |char| input.includes?(char) }
  end
end
