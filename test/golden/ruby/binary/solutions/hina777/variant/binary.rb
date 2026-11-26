class Binary
  def self.to_decimal(num)
   size = num.length 
   nums_array = num.chars.to_a 
   nums_array.each_with_index.inject(0) {|result, (a, i)| raise(ArgumentError) if a.ord > 49; result+= a.to_i * 2**(size-1 + i) } 
  end
end