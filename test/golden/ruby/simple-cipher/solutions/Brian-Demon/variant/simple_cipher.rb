class Cipher
  ALPHABET = ("a".."z").to_a
  private_constant :ALPHABET

  attr_reader :key

  def initialize(key = ALPHABET.join)
    raise ArgumentError, 'invalid chars in key' unless key.match?(/\A[a-z]+\z/)
    @key = key || 100.times.map { ALPHABET.sample }.join
    
  end

  def encode(pattern)
    pattern.each_char.with_index.map do |char, index|
      to_char(ALPHABET.index(char) + ALPHABET.index(@key[index]))
    end.join
  end

  def decode(pattern)
    pattern.each_char.with_index.map do |char, index|
      to_char(ALPHABET.index(char) + ALPHABET.index(@key[index]))
    end.join
  end

  private

  def valid?(passed_key)
    !key.empty? && key.match?(/[^a-z]/)
  end

  def to_char(char)
    ('a'.ord + char.modulo(ALPHABET.length)).chr
  end
end
