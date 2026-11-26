// Swift
// "House" @ exercism.org

struct House {
  static private let verses = [
    ["horse and the hound and the horn", "belonged to"],
    ["farmer sowing his corn", "kept"],
    ["rooster that crowed in the morn", "woke"],
    ["priest all shaven and shorn", "married"],
    ["man all tattered and torn", "kissed"],
    ["maiden all forlorn", "milked"],
    ["cow with the crumpled horn", "tossed"],
    ["dog", "worried"],
    ["cat", "killed"],
    ["rat", "ate"],
    ["malt", "lay in"],
    ["house", "Jack built."]
  ]

  static func recite(start: Int, end: Int) -> String {
    (start...end).map { verse($0) }.lazy.joined(separator: "\n")
  }
  
  static private func verse(_ n: Int) -> String {
    House.verses[(House.verses.count + n)...].lazy.reduce("This is"){
      $0 + " the " + $1.joined(separator: " that ")
    }
  }
}