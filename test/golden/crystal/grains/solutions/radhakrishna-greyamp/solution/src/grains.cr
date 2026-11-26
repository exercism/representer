# Please implement your solution to grains in this file
module Grains
  def self.square(n : Int)
    raise ArgumentError.new("not a square on a chess board") unless (1..64).includes? n
    1_u64 << n - 1
  end

  def self.total
    UInt64::MAX
  end
end
