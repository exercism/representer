class Queen {

    def row
    def column
    Queen(int row, int column) {
        this.row = row
        this.column = column
        
        if (this.row < 0 || this.row > 7 || this.column < 0 || this.column > 7)
            throw new Exception()
    }
}
