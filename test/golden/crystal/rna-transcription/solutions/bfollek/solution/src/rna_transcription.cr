# Please implement your solution to rna-transcription in this file

class RnaComplement

  def self.of_dna(nucleotides : String) : String
    nucleotides.tr "GCTA", "CGAU"
  end

end