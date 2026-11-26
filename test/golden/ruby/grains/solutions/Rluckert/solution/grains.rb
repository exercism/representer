# Grains
class Grains
  def self.square(number)
    raise ArgumentError if number > 64 || number < 1
    2**(number - 1)
  end

  def self.total
    (1..64).sum { |n| square(n) }
  end
end

module BookKeeping
  VERSION = 1
end