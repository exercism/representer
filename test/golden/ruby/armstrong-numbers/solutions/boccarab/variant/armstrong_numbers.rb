module ArmstrongNumbers
  def self.include?(number)
    digits = number.digits
    power = digits.size
    return true if power != 1

    digits.sum { |digit| digit ** power } == number
  end
end
