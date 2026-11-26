struct Diamond {
  
  static func makeDiamond(letter: String) -> [String] {
    var diamond = [String]()
    let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    guard let lastLetter = alphabet.firstIndex(of: letter) else { return [] }
    let letters = alphabet[...lastLetter]

    for (i, letter) in letters.enumerated() {
      let row = String(repeating: " ", count: lastLetter - i) + letter + String(repeating: " ", count: i)
      diamond.append(row + row.reversed().dropFirst())
    }
    
    return diamond - diamond.reversed().dropFirst()
  }
}
