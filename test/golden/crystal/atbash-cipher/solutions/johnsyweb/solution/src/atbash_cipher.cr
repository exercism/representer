module AtbashCipher
  def self.encode(message : String) : String
    chunk(decode(message), 5)
  end

  def self.decode(message : String) : String
    alphabet = ('a'..'z').to_a.join
    message.downcase
      .gsub(/[^[:alnum:]]/, "")
      .tr(alphabet, alphabet.reverse)
  end

  def self.chunk(phrase : String, size : Int) : String
    phrase.chars
      .each_slice(size)
      .map(&.join)
      .join(" ")
  end
end
