module ArmstrongNumbers
  def self.armstrong_number?(input : Number) : Bool
    original_number = input
    digits = if input == 0
      1
    else
      Math.log10(input).ceil.to_i
    end
    sum = 0
    while input > 0
      digit = input % 10
      p digit
      sum += digit ** digits
      input = (input / 10).to_i
    end
    sum == original_number
  end
end
