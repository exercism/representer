class Queen {
    def row
    def column
    def range = 0..<8

    Queen(int row, int column) {
        if(!(row in range) || !(column in range)) {
            throw new Exception("Неверная позиция ферзя! Укажите значения в пределах шахматной доски.")
        }
        this.row = row
        this.column = column
    }
}
