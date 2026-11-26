// TODO: define the 'ranks' constant
// TODO: define the 'files' constant
let ranks = 1...8
let files = "A"..."H"

func isValidSquare(rank: Int, file: String) -> Bool {
  ranks.contains(rank) && files.contains(file)
}

func getRow(_ board : [String], rank: Int) -> [String] {
  board.filter { 
    String($0.prefix(1)) == String(rank)
  }
}
