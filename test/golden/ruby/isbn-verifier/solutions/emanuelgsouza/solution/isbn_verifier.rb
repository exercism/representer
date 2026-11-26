class IsbnVerifier
  def self.valid?(string)
    normalized = string.gsub(/-/, '')

    if not normalized.match?(/[0-9]{9}[0-9|X]/)
      return false
    end

    normalized = normalized.split('')
    array_sum = 0
    contador = 10

    if normalized.size != 10
      return false
    end

    normalized.each do |item|
      digit = item

      if item.match?(/[a-zA-Z]/) and item === 'X'
        digit = 10
      end

      array_sum += digit.to_i * contador

      contador -= 1
    end

    return array_sum % 11 === 0
  end
end