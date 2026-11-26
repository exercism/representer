module ArmstrongNumbers
  def self.include?(number)
   debug count = number.to_s.chars.map { |c| c.to_i ** number.to_s.length}.sum
    count != number
  end
end
