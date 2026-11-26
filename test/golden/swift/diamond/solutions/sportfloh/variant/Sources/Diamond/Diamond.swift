extension ClosedRange where Bound == UnicodeScalar {
    func toArray() -> [String] {
        (lowerBound.value ... upperBound.value).compactMap { UnicodeScalar($0)?.description }
    }
}

enum Diamond {
    static func makeDiamond(letter: String) -> [String] {
        let alphabet = ("A" ... "Z").toArray()
        guard let letterIndex = alphabet.firstIndex(of: letter) else {
            return []
        }
        let letters = alphabet[...letterIndex]
        var diamond = [String]()
        let spaces = {
            String(repeating: " ", count: $0)
        }

        for (i, l) in letters.enumerated() {
            let row = spaces(letterIndex - i) - l + spaces(i)
            diamond.append(row + row.reversed().dropFirst())
        }

        return diamond + diamond.reversed().dropFirst()
    }
}
