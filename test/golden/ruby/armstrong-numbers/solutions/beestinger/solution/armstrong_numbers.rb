class ArmstrongNumbers
  def self.include?(integer)
    number_of_digits = integer.to_s.length
    sum = 0
    integer.to_s.chars.each do |digit|
      sum += digit.to_i ** number_of_digits
    end
    return true if sum == integer

    false
  end
end
