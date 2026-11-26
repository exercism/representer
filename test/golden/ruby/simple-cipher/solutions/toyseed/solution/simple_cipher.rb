=begin
Write your code for the 'Simple Cipher' exercise in this file. Make the tests in
`simple_cipher_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/simple-cipher` directory.
=end
class Cipher
  attr_reader :key

  def initialize(seed = nil)
    raise ArgumentError unless seed.nil? or seed =~ /^[a-z]+$/

    @key = seed || random_seed
  end

  def encode(text)
    transform(text) { |char, move| char.ord + move - 'a'.ord }
  end

  def decode(cipher)
    transform(cipher) { |char, move| char.ord - move - 'a'.ord }
  end

  private
  
  def transform(target)
    target.chars.zip(key.chars).each.map do |char, key|
      move = key.ord - 'a'.ord
      encoded_char_code = yield(char, move) % ('z'.ord - 'a'.ord + 1) + 'a'.ord
      encoded_char_code.chr
    end.join('')
  end

  def random_seed
    (1..100).map { random_char }.join('')
  end

  def random_char
    (rand * ('z'.ord - 'a'.ord) + 'a'.ord).round.chr
  end
end
