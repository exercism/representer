class Array

  def method_missing(m, *args, &block)
    return self.to_enum(m) unless block_given?
    result = []
    index = 0
    while index < self.length
      if m.eql?(:keep)
        result << self[index] if block.call(self[index])
      elsif m.eql?(:discard)
        result << self[index] unless block.call(self[index])
      end      
      index = index + 1
    end
    result       
  end
end