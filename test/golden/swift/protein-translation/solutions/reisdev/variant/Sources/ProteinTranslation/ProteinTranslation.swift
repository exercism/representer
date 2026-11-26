enum TranslationError: Error {
    case invalidCodon
}

func protein(for codon: String) throws -> String {    
    switch codon {
        case "AUG":
            return "Methionine"
        case "UUU", "UUC":
            return "Phenylalanine"
        case "UUA", "UUG":
            return "Leucine"
        case "UCU", "UCC", "UCA", "UCG":
            return "Serine"
        case "UAU", "UAC":
            return "Tyrosine"
        case "UGU", "UGC":
            return "Cysteine"
        case "UGG":
            return "Tryptophan"
        case "UAA", "UAG", "UGA":
            return "STOP"
        default:
            throw TranslationError.invalidCodon
    }
}

func translationOfRNA(rna strand: String) throws -> [String] {
    // Write your code for the 'Protein Translation' exercise in this file.
    guard strand.count >= 0 else { return [] }

    var proteins: [String] = []

    for i in stride(from: 0, to: strand.count, by: 3) {

        let startIndex = strand.index(strand.startIndex, offsetBy: i)
        let endIndex = strand.index(startIndex, offsetBy: 3, limitedBy: strand.endIndex) ?? strand.endIndex

        let codon = String(strand[startIndex..<endIndex])
        let protein = try protein(for: codon)

        if protein == "STOP" {
            break
        }
        
        proteins.append(protein)
    }

    return proteins
}
