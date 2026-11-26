class RotationalCipher

  class << self

    LOWER_ALPHABET = ('a'..'z')
    UPPER_ALPHABET = ('A' .. 'Z')
    NUMBER_OF_LETTERS_IN_ALPHABET = LOWER_ALPHABET.count

    def convert_upcase_letter(letter, rotation)
      ("A".ord + (letter.ord - 'A'.ord + rotation) % NUMBER_OF_LETTERS_IN_ALPHABET ).chr 
    end

    def convert_lowercase_letter(letter, rotation)
      ("a".ord + (letter.ord - 'a'.ord - rotation) % NUMBER_OF_LETTERS_IN_ALPHABET).chr 
    end


    def encrypt_letter(letter, rotation)

      return letter unless LOWER_ALPHABET.include?(letter) || UPPER_ALPHABET.include?(letter) 

      return convert_lowercase_letter(letter, rotation) if LOWER_ALPHABET.include?(letter)

      return convert_upcase_letter(letter, rotation)
    end

    def rotate(message, rotation)

      message.chars.collect do |letter|
        encrypt_letter(letter, rotation)
      end.join

    end
  end
end
