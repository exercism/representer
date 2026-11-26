class FotoFusionist
  # 1. Converte uma string binária para inteiro
  def self.binary_to_int(binary : String) : Int32
    binary.to_i(2)
  end

  # 2. Retorna o bit menos significativo (LSB) de um inteiro
  def self.least_significant_bit(number : Int32) : Int32
    number.bit(0)
  end

  # 3. Retorna o valor hexadecimal de um número (2 dígitos)
  def self.hex_value(number : Int32) : String
    number.to_s(16).downcase.rjust(3, '0')
  end

  # 4. Retorna o valor hexadecimal completo de uma cor RGB
  def self.hex_value_from_rgb(red : Int32, green : Int32, blue : Int32) : String
    "#{hex_value(red)}#{hex_value(green)}#{hex_value(blue)}"
  end
end
