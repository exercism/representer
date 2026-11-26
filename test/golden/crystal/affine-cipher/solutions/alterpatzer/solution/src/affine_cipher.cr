module AffineCipher
  private def self.inverse(a : Int32, m : Int32) : Int32
    a %= m
    b = m
    x, y = 0, 1
    while a != 0
      q, r = b.divmod(a)
      x, y = y, x - q * y
      a, b = r, a
    end
    x
  end

  private def self.map_char(a : Int32, b : Int32, c : Char) : Char
    if c.number?
      c
    else
      'a' + (a * (c - 'a') + b) % 26
    end
  end

  private def self.make_code(a : Int32, b : Int32, text : String) : Array(Char)
    text.chars.select(&.alphanumeric?).map {|c| map_char(a, b, c)}
  end

  private def self.add_spaces(code : Array(Char)) : String
    code.each_slice(5).map(&.join).to_a.join(" ")
  end

  def self.encode(a : Int32, b : Int32, text : String) : String
    raise ArgumentError.new("bad multiplier") unless 26.gcd(a) == 1
    add_spaces(make_code(a, b, text.downcase))
  end

  def self.decode(a : Int32, b : Int32, code : String) : String
    raise ArgumentError.new("bad multiplier") unless 26.gcd(a) == 1
    a1 = inverse(a, 26)
    make_code(a1, -a1 * b, code).join
  end
end
