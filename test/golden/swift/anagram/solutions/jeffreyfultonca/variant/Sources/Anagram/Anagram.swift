
// MARK: - Anagram

struct Anagram {
    
    // MARK: - Stored properties
    
    let word: String
    
    // MARK: - Access
    
    func match(
        _ candidates: [String]) -> [String]
    {
        return candidates
            .filter({ $0.lowercased().isAnagram(of: word.lowercased()) })
    }
}

// MARK: - String extension

extension String {
    func isAnagram(of other: String) -> Bool {
        guard self != other else { return true }
        return self.sorted() == other.sorted()
    }
}
