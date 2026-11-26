# frozen_string_literal: true

# rotational cipher realization
class RotationalCipher
  ALPHABET = 'abcdefghijklmnopqrstuvwxyz'

  def self.rotate(string, rotation)
    new(string, rotation).rotate
  end

  attr_reader :string, :rotation

  def initialize(string, rotation)
    @string = string
    @rotation = rotation
  end

  def rotate
    string.each_char.map do |char|
      old_index = ALPHABET.index(char.downcase)
      new_char = old_index ? ALPHABET[(old_index + rotation) % 26] : char
      new_char.upcase! if upcase?(char)
      new_char
    end.join
  end

  private

  def upcase?(char)
    char.upcase == char
  end
end
