module Grains
  # Write your code for the 'Grains' exercise in this file.
  def self.square(number : Number) : Number
    raise ArgumentError.new "Number must be between 1 and 64 inclusive" if number < 1 || number > 64
    2.to_u64 ** (number - 1)
  end

  def self.total : Number
    (1..64).sum { |n| square(n) }
  end
end
