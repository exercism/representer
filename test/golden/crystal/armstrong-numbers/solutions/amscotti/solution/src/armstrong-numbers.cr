module ArmstrongNumbers
  extend self

  def armstrong_number?(input : Number) : Bool
    number = input.to_s
    length = number.size

    input == number.chars.map { |i| i.to_i ** length }.sum
  end
end
