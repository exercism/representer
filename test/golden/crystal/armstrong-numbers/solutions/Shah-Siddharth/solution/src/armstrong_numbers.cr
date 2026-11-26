module ArmstrongNumbers
  def self.armstrong_number?(input : Number) : Bool
    input == input.digits.sum {|num| num ** input.digits.size }
  end
end
