enum NucleotideCountErrors: Error {
    case invalidNucleotide
}

class DNA {
    let targetCharacterSet: Set<Character> = ["A", "C", "G", "T"]
    var strand: String = ""
    
    init(strand: String) throws {
        guard allCharactersExist(strand) else {throw NucleotideCountErrors.invalidNucleotide}
        self.strand = strand
    }

    func counts() -> [String: Int] {
        var res: [String: Int] = ["A": 0, "C": 0, "G": 0, "T": 0]

        for char in strand{
            res[String(char)]! += 1
        }
        return res
    }

    private func allCharactersExist(_ inputString: String) -> Bool {
        return !inputString.contains { char in
            !targetCharacterSet.contains(char)
        }
    }
    
}