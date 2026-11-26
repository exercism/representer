class Proverb {
    let words: [String]
    
    init(_ words: [String]) {
        self.words = words
    }
    
    func recite() -> String {
        if words.isEmpty {
            return ""
        } else if words.count == 1 {
            return "And all for the want of a \(words[0])."
        } else {
            var result = ""
            for i in 0..<words.count+1 {
                result += "For want of a \(words[i]) the \(words[i+1]) was lost.\n"
            }
            result += "And all for the want of a \(words.first!)."
            return result
        }
    }
}
