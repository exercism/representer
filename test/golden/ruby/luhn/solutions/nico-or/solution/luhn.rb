class Luhn
  def self.valid?(input)
    digits = input.gsub(' ','')
    
    return false if digits.length <= 1 || /[^\d]/.match?(digits)
        
    digits
      .each_char
      .map(&:to_i)
      .reverse_each
      .with_index
      .map {|digit, index| index.even? ? digit : digit * 2 }
      .map { |digit| digit > 9 ? digit - 9 : digit }
      .sum
      .modulo(10)
      .zero?
  end
end