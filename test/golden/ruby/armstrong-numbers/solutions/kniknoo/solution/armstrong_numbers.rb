class ArmstrongNumbers
  def self.include?(number)
    number.digits.sum { |x| x**number.digits.size } == number
  end
end
