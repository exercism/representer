enum QueenError: Error {
    case inValidRow
    case inValidColumn
}

class Queen {
    let row: Int
    let column: Int

    init(row: Int, column: Int) throws {
        guard (0...7).contains(row) else {
            throw QueenError.inValidRow
        }
        guard (0...7).contains(column) else {
            throw QueenError.inValidColumn
        }
        self.row = row
        self.column = column
    }

    func canAttack(other: Queen) -> Bool {
        return row == other.row || column == other.column ||
        abs(row - other.row) == abs(column - other.column)
    }
}