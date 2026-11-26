struct Anagram {
    let word: String
    let dict: [Character: Int]

    init(word: String) {
        self.word = word.lowercased()
        self.dict = self.word.reduce(into:[:]){ $0[$1] = $0[$1, default:1] + 1 }
    }

    func match(_ targets: [String]) -> [String] {
        return targets.filter{ $0.lowercased() != self.word && $0.count == word.count && isAnagram($0.lowercased())}
    }

    func isAnagram(_ target: String) -> Bool {
        return self.dict == target.reduce(into:[:]){ $0[$1] = $0[$1, default:1] + 1 }
    }
}
