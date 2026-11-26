class IsbnVerifier
  def self.valid?(isbn)
    isbn = isbn.delete("-")
    return false if isbn !~ /^\d{9}[\dX]$/
    isbn = isbn.chars.map { |a| a == "X" ? 10 : a.to_i }
    isbn.zip(10.downto(1).to_a).map { |a,b| a*b }.sum % 11 == 0
  end
end
