class Hamming
  def self.compute strand_1, strand_2
    raise ArgumentError if strand_1.length != strand_2.length

    strand_1.chars
            .zip(strand_2.chars)
            .count { |s1, s2| s1 != s2 }
  end
end