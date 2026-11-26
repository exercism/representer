module NucleotideCount
  def self.nucleotide_counts(nucleotides : String) : Hash(Char, Int32)
    init_counts = {'A' => 0, 'C' => 0, 'G' => 0, 'T' => 0}
    init_counts.merge nucleotides.each_char.to_a.tally_by { |n| raise ArgumentError.new unless init_counts.has_key? n; n }
  end
end
