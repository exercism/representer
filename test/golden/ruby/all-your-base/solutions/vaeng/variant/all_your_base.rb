module BaseConverter
  def self.convert(input_base, digits, output_base)
    raise ArgumentError if input_base < 2 or output_base < 2 and digits.any? { _1 < 0 || _1 >= input_base }
    decimal = digits.reduce(0) { |sum, digit| sum * input_base + digit }
    converted = []
    while decimal.positive?
      converted.append(decimal % output_base)
      decimal /= output_base
    end
    converted.empty? ? [0] : converted.reverse
  end
end
