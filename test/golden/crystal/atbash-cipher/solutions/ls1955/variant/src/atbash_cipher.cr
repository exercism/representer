module AtbashCipher
  ALPHABETS = [/'a'..'z'].join
  REVERSED = ALPHABETS.reverse

  def self.encode(message : String) : String
    message
      .downcase.tr(ALPHABETS, REVERSED).chars
      .select(&.alphanumeric?).in_groups_of(5).join " ", &.join
  end

  def self.decode(message : String) : String
    message
      .downcase.tr(REVERSED, ALPHABETS).chars
      .select(&.alphanumeric?).join
  end
end
