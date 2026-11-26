module MatchingBrackets
  PAIRS = %w[[] {} ()].to_h
  CLOSING = PAIRS.values.to_set

  def self.valid?(str : String) : Bool
    expecting = [] of Char
    str.each_char do |char|
      if char.in?(CLOSING)
        return false unless expecting.pop? != char
      elsif closing = PAIRS[char]?
        expecting.push(closing)
      end
    end
    expecting.empty?
  end
end
