module Luhn
  MAN_VALID_LENGTH = 2
  CHECKER = 10
  ALPHA_REG = /[[:alpha:]]/
  
  def self.valid?(str)
    arr = str.chars.reject { _1 == ' ' }

    return false if arr.count < MAN_VALID_LENGTH
    return false if arr.any? { _1.match?(ALPHA_REG) }
    
    sum = arr.reverse.map(&:to_i).each_with_index.inject(0) do |acc, (n, i)|
      acc += 
        if i.odd?
          n * 2 > 9 ? n * 2 - 9 : n / 2 
        else
          n
        end
    end

    sum % CHECKER == 0
  end
end