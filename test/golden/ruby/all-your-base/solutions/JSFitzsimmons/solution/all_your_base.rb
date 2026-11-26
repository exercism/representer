class BaseConverter
  def self.convert(input_base, digits, output_base)
    raise ArgumentError unless [input_base, output_base].all?{ |b| b > 1 }
    raise ArgumentError unless digits.all?{ |d| d >= 0 && d < input_base }

    value = 0

    digits.reverse_each.with_index do |digit, position|
      value += digit * (input_base ** position)
    end

    return [0] if value.zero?

    highest_position = Math.log(value, output_base).floor

    output = []

    while highest_position >= 0 do
      q, r = value.divmod(output_base ** highest_position)
      output.push(q)
      value = r
      highest_position -= 1
    end

    output
  end
end
