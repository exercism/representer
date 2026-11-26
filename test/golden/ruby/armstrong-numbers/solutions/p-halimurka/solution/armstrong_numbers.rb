class ArmstrongNumbers
    def self.include?(number)
      number.digits.reverse.map {|n| n ** number.digits.size}.reduce(:+) == number
    end
end