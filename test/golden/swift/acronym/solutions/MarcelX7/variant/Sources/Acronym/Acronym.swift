import Foundation
struct Acronym {
  static func abbreviate(_ inString: String) -> String {
    let processedString = inString.replacingOccurrences(of: "-", with: " ")
    let wordSeparators = CharacterSet.whitespacesAndNewlines
    let words = processedString.components(separatedBy: wordSeparators).filter {
      !$0.isEmpty
    }
    var acronymLetters: [String] = []
    for word in words {
      if let firstCharacter = word.first(where: { $0.isLetter }) {
        acronymLetters.append(String(firstCharacter).lowercased())
      }
    }
    return acronymLetters.joined()
  }
}