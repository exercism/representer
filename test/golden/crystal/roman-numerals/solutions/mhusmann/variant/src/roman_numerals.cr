# Please implement your solution to roman-numerals in this file
struct Int
  Romans = {0 => "", 1 => "I", 2 => "II", 3 => "III", 4 => "IV", 5 => "V", 6 => "VI", 7 => "VII", 8 => "VIII", 9 => "IX", 10 => "X",
            20 => "XX", 30 => "XXX", 40 => "XL", 50 => "L", 60 => "LX", 70 => "LXX", 80 => "LXXX", 90 => "XC", 100 => "C",
            200 => "CC", 300 => "CCC", 400 => "CD", 500 => "D", 600 => "DC", 700 => "DCC", 800 => "DCCC", 900 => "CM",
            1000 => "M", 2000 => "MM", 3000 => "MMM"} of Int32 => String

  def to_roman : String
    raise "Only numbers < 4000 are allowed" if self >= 4000
    result = ""
    number = self
    [1000, 100, 10, 1].each do |mul|
      quot, number = number.divmod(mul)
      result += Romans[quot/mul].to_s
    end
    result
  end
end
