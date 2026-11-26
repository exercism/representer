# frozen_string_literal: true

class Cipher
  ALPHABET = ('a'..'z').to_a
  KEY_SIZE = 100

  attr_reader :key

  def initialize(key = nil)
    @key = key || generated_key
    raise ArgumentError if invalid?(@key)
  end

  def encode(text)
    text.chars.zip(key.chars).map do |text_char, key_char|
      position = ALPHABET.index(text_char) + ALPHABET.index(key_char)
      ALPHABET[position % ALPHABET.length]
    end.join
  end

  def decode(text)
    text.chars.zip(key.chars).map do |text_char, key_char|
      position = ALPHABET.index(text_char) - ALPHABET.index(key_char)
      ALPHABET[position % ALPHABET.length]
    end.join
  end

  private

  def generated_key
    KEY_SIZE.times.map { ALPHABET.sample }.join
  end

  def invalid?(key)
    key.empty? || key =~ /[^a-z]/
  end
end
