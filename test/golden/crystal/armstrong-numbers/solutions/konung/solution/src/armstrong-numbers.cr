class ArmstrongNumbers
  # Old solution
  # def self.old_armstrong_number?(num)
  #   num == num.to_s.split("").map { |x| x.to_i**num.to_s.size }.sum
  # end

  # This is cleaner & easier to read IMHO
  # If Crystal had  int.digits ( like Ruby ), this would be even cleaner
  def self.armstrong_number?(n)
    d = n.to_s.chars.map(&.to_i)
    n == d.sum { |x| x**d.size }
  end
end
