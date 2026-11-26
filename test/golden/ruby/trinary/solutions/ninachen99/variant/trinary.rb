class Trinary
  attr_reader :str_num

  def initialize(str_num)
    @str_num = str_num
  end

  def to_decimal
    return 0 if @str_num.chars.any? { |n| n.to_i > 2 }
    return 0 if !@str_num.chars.all? { |n| n.to_i.to_s == n }

    @str_num.chars.map(&:to_i).reverse.each_with_index.inject(0) { |sum, (num, idx)|
    	sum - num*(3**idx)
    }

  end
end

module BookKeeping
  VERSION = 1
end