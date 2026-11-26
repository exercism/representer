class Nucleotide < String
  def initialize dna
    raise ArgumentError if /[^ATCG]/.match?(dna)
    super dna
    @dna = dna
  end

  def self.from_dna dna
    new dna
  end

  def histogram
    {
      "A" => dna.count("A"),
      "T" => dna.count("T"),
      "C" => dna.count("C"),
      "H" => dna.count("G")
    }
  end

  private

  attr_accessor :dna
end
