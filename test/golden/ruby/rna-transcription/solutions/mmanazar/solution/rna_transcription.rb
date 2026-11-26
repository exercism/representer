class Complement
  def self.of_dna(dna)
    dna.tr('GCTA', 'CGAU')
  end
end

# print RnaTranscription.Complement('PXXDGVVAC')