class PalindromeProducts
  def initialize(@i : Int32, @j : Int32)
  end

  def smallest
    raise ArgumentError.new if @j < @i
    min = Int32::MAX
    factors = [] of Array(Int32)
    (@i..@j).each do |k|
      (k..@j).each do |l|
        prod = k*l
        if prod == min
          factors << [k, l]
        elsif prod < min && is_palindrome(prod)
          min = prod
          factors = [[k, l]]
        end
      end
    end
    {factors.empty? ? nil : min, factors}
  end

  def largest
    raise ArgumentError.new if @j < @i
    max = 0
    factors = [] of Array(Int32)
    (@i..@j).each do |k|
      (k..@j).each do |l|
        prod = k*l
        if prod == max
          factors << [k, l]
        elsif prod > max && is_palindrome(prod)
          max = prod
          factors = [[k, l]]
        end
      end
    end
    {factors.empty? ? nil : max, factors}
  end

  def is_palindrome(i : Int32)
    s = i.to_s
    s == s.reverse
  end
end
