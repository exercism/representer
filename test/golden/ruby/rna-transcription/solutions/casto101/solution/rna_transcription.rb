class Complement
  VERSION = 3
  
  def self.of_dna(nucleotide)
    raise ArgumentError, "Invalid input" if /[^GCTA]/.match(nucleotide)
    
    nucleotide.gsub(/[GCTA]/, {"C" => "G", "G" => "C", "T" => "A", "A" => "U"})
  end
  
end