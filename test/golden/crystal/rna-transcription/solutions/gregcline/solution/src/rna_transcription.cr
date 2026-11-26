class RnaComplement
  def self.of_dna(strand)
    strand.tr("GCTA", "CGAU")
  end
end