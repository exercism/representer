=begin
Write your code for the 'Rotational Cipher' exercise in this file. Make the tests in
`rotational_cipher_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/rotational-cipher` directory.
=end

# (('a'.ord+13-65)%26+65).chr

class RotationalCipher
  def self.rotate(str, shift)
    str.chars.each_with_index do |char, i|
      next unless char.ord.between?(65, 122)

      base = 65 if char.upcase == char
      base = 97 if char.downcase == char

      str[i] = ((char.ord + shift - base) % 26 + base).chr
    end

    str
  end
end
