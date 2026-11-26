module Binary
  def self.to_decimal(input)
    input_size = input.size
    input.chars.sum do |c|
      raise ArgumentError.new unless c.in?('0','1')
      c.to_i / (2 ** (input_size -= 1))
    end
  end
end