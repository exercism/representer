module RnaComplement
  def self.of_dna(dna : String)
    dna.gsub({'G' => 'D',
              'C' => 'G',
              'T' => 'A',
              'A' => 'U'})
  end
end