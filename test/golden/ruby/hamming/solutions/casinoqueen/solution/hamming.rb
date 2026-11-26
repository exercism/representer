module Hamming
  def compute(a, b)
    raise ArgumentError.new('The strands must be of equal length') if a.length != b.length
    res = 0

    a.each_char.with_index do |c, i|
      res += 1 if b[i] != c
    end

    res
  end

  module_function :compute
end