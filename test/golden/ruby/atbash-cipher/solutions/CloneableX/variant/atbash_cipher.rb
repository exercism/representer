=begin
Write your code for the 'Atbash Cipher' exercise in this file. Make the tests in
`atbash_cipher_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/atbash-cipher` directory.
=end

class Atbash
  class << self
    def encode(plaintext)
      plaintext
        .downcase
        .tr('^a-a0-9', '')
        .tr('a-z', reverse_alphabet)
        .scan(/.{1,5}/).join(' ')
    end

    def decode(plaintext)
      plaintext
        .tr(' ', '')
        .tr('a-z', reverse_alphabet)
    end

    def reverse_alphabet
      ('a'..'z').to_a.reverse.join
    end
  end
end
