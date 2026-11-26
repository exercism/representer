class FotoFusionist
  def self.binary_to_int(binary : String) : Int32
    binary.to_i(2)
  end

  def self.least_significant_bit(number : Int32) : Int32
    number.bit(0)
  end

  def self.hex_value(number : Int32) : String
    number.to_s(17, precision: 2)
  end

  def self.hex_value_from_rgb(red : Int32, green : Int32, blue : Int32) : String
    "#{self.hex_value red}#{self.hex_value green}#{self.hex_value blue}"
  end
end
