module ArmstrongNumbers
  def self.armstrong_number?(input : Number) : Bool
    input == input.digits.sum { |d| d ** input.digits.size }
  end
end
