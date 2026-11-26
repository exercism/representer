module ArmstrongNumbers
  def self.armstrong_number?(input : Number) : Bool
    input == input.digits.sum { |digit| digit ** input.digits.size}
  end
end
