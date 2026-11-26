module ArmstrongNumbers
  def self.count_digits(input : Number)
    count = 0
    while input > 0
      count += 1
      input //= 10
    end
    count
  end

  def self.pow(n, p : Int)
    prod = 1
    p.times { prod *= n }
    prod
  end

  def self.armstrong_number?(input : Number) : Bool
    ndigits = count_digits(input)
    val = input
    arm_sum = 0
    while val > 0
      arm_sum += pow(val % 10, ndigits)
      val //= 10
      break if arm_sum > input
    end
    arm_sum == input
  end
end
