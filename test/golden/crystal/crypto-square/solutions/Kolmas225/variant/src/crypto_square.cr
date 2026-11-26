module CryptoSquare
  extend self

  def ciphertext(text : String) : String
    cipher_size = uninitialized Int32
    text.delete { |c| !c.alphanumeric? }
      .downcase
      .tap { |_text| return "" if _text.empty? }
      .tap { |_text| cipher_size = _text.size }
      .chars
      .in_groups_of(Math.sqrt(cipher_size).floor.to_i, ' ')
      .transpose
      .join(' ', &.join)
  end
end
