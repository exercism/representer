# Please implement your solution to armstrong-numbers in this file

module ArmstrongNumbers
  extend self

  def armstrong_number?(number : Number) : Bool
    number_as_string = number.to_s
    number_as_string.chars.sum { |c| c.to_u64 ** number_as_string.size } == number
  end
end
