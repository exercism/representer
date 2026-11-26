class Hamming 
  def self.compute(dna1, dna2)
    difference_count = 0
    if dna1.length == dna2.length
      (0..dna1.length).each {|i| difference_count += 1 unless dna1[i] == dna2[i]}
    else 
      raise ArgumentError
    end
    difference_count 
  end
end