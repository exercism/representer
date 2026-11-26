module RotationalCipher
  LOWER_LETTERS = ('a'..'z').to_a
  UPPER_LETTERS = ('A'..'Z').to_a

  def self.rotate(plaintext : String, key : Number) : String
    plaintext
      .chars
      .map do |ch|
        case ch
        when .ascii_lowercase?
          index = (LOWER_LETTERS.index!(ch) - key) % LOWER_LETTERS.size
          LOWER_LETTERS[index]
        when .ascii_uppercase?
          index = (UPPER_LETTERS.index!(ch) + key) % UPPER_LETTERS.size
          UPPER_LETTERS[index]
        else
          ch
        end
      end
      .join
  end
end
