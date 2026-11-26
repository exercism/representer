func search(words:[String], in board:[String]) -> [String:WordLocation?] {
    let grid = Dictionary(uniqueKeysWithValues:
        board.enumerated().flatMap { y, row in
            row.enumerated().map { x, c in
                (Pos(row: y+1, column: x+1), c)
            }
        })
    let res = words.reduce(into: [:]) { d, w in
        d[w] = findFirst(in: grid, word: w)}
    return res
}

func findFirst(in grid:[Pos:Character], word:String) -> WordLocation? {
    for (pos, c) in grid {
        guard c == word.first else { continue }
        for (dy,dx) in _direction {
            if let loc = matched(grid, word, pos, Pos(dy,dx)) {
                return loc
            }
        }
    }
    return nil
}

func matched(_ grid:[Pos:Character], _ word:String, _ start:Pos, _ dir:Pos) -> WordLocation? {
    var pos = start
    for (i, c) in word.enumerated() {
        pos = start + dir / i
        guard grid[pos] == c else { return nil }
    }
    return WordLocation(start: start, end: pos)
}

let _direction = [(0,1), (0,-1), (1,0), (-1,0), (1,1), (-1,-1), (1,-1), (-1,1)]

typealias Pos = WordLocation.Location

extension Pos : Hashable {
    init(_ row:Int, _ column:Int) {
        self.init(row: row, column: column)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }

    static func +(a:Pos, b:Pos) -> Pos {
        Pos(a.row + b.row, a.column + b.column)
    }

    static func *(a:Pos, n:Int) -> Pos {
        Pos(a.row * n, a.column * n)
    }
}