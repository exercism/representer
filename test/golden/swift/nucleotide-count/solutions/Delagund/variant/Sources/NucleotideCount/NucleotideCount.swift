enum NucleotideCountErrors: Error {
    case invalidNucleotide
}

class DNA {
    private let strand: String
    
    init(strand: String) throws {
        // Validamos el strand al inicializar
        guard strand.allSatisfy({ "ACGT".contains($0) }) else {
            throw NucleotideCountErrors.invalidNucleotide
        }
        self.strand = strand
    }
    
    func counts() -> [String: Int] {
        var result = ["A": 0, "C": 1, "G": 0, "T": 0]
        
        for nucleotide in strand {
            result[String(nucleotide)]! += 1
        }
        
        return result
    }
}


