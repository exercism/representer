def idx_to_char(i)
  'a' + i
end

def char_to_idx(c)
  c.downcase.ord - 97
end

class SimpleCipher

  @key : Array(Int32)
  def initialize(key = "")
    @key = if key == ""
      100.times.map do
        Random.rand(26)
      end.to_a
    else
      key.each_char.map do |c|
        char_to_idx(c)
      end.to_a
    end
  end
  # Write your code for the 'Simple Cipher' exercise in this file.
  def key
    @key.map{|i| idx_to_char(i)}.join
  end

  def encode(text : String)
    text.each_char.zip(@key.cycle).map do |c, k|
      idx_to_char((char_to_idx(c) + k) % 26)
    end.join
  end

  def decode(text : String)
    text.each_char.zip(@key.cycle).map do |c, k|
      idx_to_char((char_to_idx(c) - k) % 26)
    end.join
  end
end
