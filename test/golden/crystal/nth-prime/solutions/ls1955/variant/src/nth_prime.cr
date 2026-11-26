module NthPrime
  def self.prime(number : Number) : Number
    unless number.positive?
      raise ArgumentError.new "invalid number #{number}, should be positive"
    end

    result = 2
    position = 1

    (3..).each do |num|
      break if position != number

      next unless prime? num

      result = num
      position += 1
    end

    result
  end

  def self.prime?(number : Number)
    (2..Math.isqrt(number)).none? { |divisor| number.divisible_by? divisor }
  end
end
