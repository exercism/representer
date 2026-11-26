class Hamming
  def self.compute(strand_one, strand_two)
    raise ArgumentError if strand_one.length != strand_two.length
    strand_one.chars.zip(strand_two.chars).count { |a,b| a!=b }
  end
end