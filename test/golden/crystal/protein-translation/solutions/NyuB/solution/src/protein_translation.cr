module ProteinTranslation
  def self.proteins(strand : String) : Array(String)
    res = [] of String
    remaining_strand = strand
    while !remaining_strand.nil? && remaining_strand.size > 0
      codon_index = 0
      found = false
      while codon_index < codons_to_proteins.size
        cp = codons_to_proteins[codon_index]
        if remaining_strand.starts_with?(cp[0])
          if cp[1] == "STOP"
            return res
          end
          found = true      
          res.push(cp[1])
          remaining_strand = remaining_strand[cp[0].size ..]?
          break
        end
        codon_index += 1
      end
      if !found
        raise ArgumentError.new("Unknown Codon")
      end
    end
    return res
  end

  def self.codons_to_proteins
    [
      {"AUG", "Methionine"},
      {"UUU", "Phenylalanine"},
      {"UUC", "Phenylalanine"},
      {"UUA", "Leucine"},
      {"UUG", "Leucine"},
      {"UCU", "Serine"},
      {"UCC", "Serine"},
      {"UCA", "Serine"},
      {"UCG", "Serine"},
      {"UAU", "Tyrosine"},
      {"UAC", "Tyrosine"},
      {"UGU", "Cysteine"},
      {"UGC", "Cysteine"},
      {"UGG", "Tryptophan"},
      {"UAA", "STOP"},
      {"UAG", "STOP"},
      {"UGA", "STOP"},
    ]
  end
end
