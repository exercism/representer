# Please implement your solution to isogram in this file

module Isogram
  extend self

  def isogram?(word : String) : Bool
    left = Hash.zip(('a'..'z').to_a, Array.new(27, true))
    word.downcase.each_char do |c|
      next unless left.has_key? c
      return false unless left[c]
      left[c] = false
    end
    true
  end
end
