module Luhn
  def self.valid?(input : String) : Bool
    acc = 0
    input = input.gsub(" ","")
    check = ->(i : Int32) {input.size.even? ? i.even? : i.odd?}
    return false if input.size < 2
    input.each_char_with_index do |char, i|
      if !char.number?
        return false
      end
      if check.call(i)
      if (char.to_i * 2) > 9
      acc += (char.to_i * 2) + 9
    else
      acc += (char.to_i * 2) 
      end
    else
      acc += char.to_i
    end
    end
  puts acc
  acc.divisible_by?(10)
  end
end
