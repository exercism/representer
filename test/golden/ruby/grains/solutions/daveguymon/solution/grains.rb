class Grains
  def self.square(number)
    raise ArgumentError unless (1..64).to_a.include?(number)
    2**(number-1)
  end

  def self.total
    square = 64
    total = 0

    square.times do
      total += 2**(square-1)
      square -= 1
    end

    total
  end
end
