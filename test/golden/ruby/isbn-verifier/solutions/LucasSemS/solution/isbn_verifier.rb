class IsbnVerifier
  def self.valid?(isbn)
    # Remove hífens
    digits = isbn.delete('-')

    # ISBN-10 deve ter exatamente 10 caracteres
    return false unless digits.length == 10

    sum = 0
    digits.chars.each_with_index do |char, idx|
      value = if idx == 9 && char.upcase == 'X'  # último dígito pode ser X
                10
              elsif char =~ /\d/                 # dígitos 0-9
                char.to_i
              else
                return false                     # caracteres inválidos
              end
      sum += value * (10 - idx)
    end

    sum % 11 == 0
  end
end
