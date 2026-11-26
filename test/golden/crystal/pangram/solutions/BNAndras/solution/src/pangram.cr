class Pangram
  ALL_LOWERCASE = ('a'..'z')

  def self.pangram?(input : String) : Bool
    lowered = input.downcase.chars
    ALL_LOWERCASE.all? { |char| lowered.includes? char }
  end
end
