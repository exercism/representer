class Minesweeper {
  static adjacentOffsets() {
    return [
      [-1, -1], [0, -1], [1, -1],
      [-1,  0],          [1,  0],
      [-1,  1], [0,  1], [1,  1]
    ]
  }

  static incrementCell(newGrid, x, y) {
    if ((0...newGrid.count).contains(y) &&
        (0...newGrid[y].count).contains(x) &&
        newGrid[y][x] != "*") {
        newGrid[y][x] = newGrid[y][x] == " " ? 1 : newGrid[y][x] + 1
      }
  }
  
  static placeMineAndUpdateCounts(newGrid, x, y) {
    newGrid[y][x] = "*"
    for (offset in Minesweeper.adjacentOffsets()) {
      incrementCell(newGrid, x + offset[0], y + offset[1])
    }
  }
  
  static annotate(minefield) {
    var totalRows = minefield.count
    if (totalRows == 0) return []
    
    var totalColumns = minefield[0].count
    if (totalColumns == 0) return [""]
    
    var annotatedGrid = List.filled(totalRows, null).map{ List.filled(totalColumns, " ")}.toList
    
    for (rowIndex in 0...totalRows) {
      var currentRow = minefield[rowIndex]
      var columnIndex = currentRow.indexOf("*")
      
      while (columnIndex != -1) {
        placeMineAndUpdateCounts(annotatedGrid, columnIndex, rowIndex)
        if (columnIndex == currentRow.count - 1) {
          break
        }
        columnIndex = currentRow.indexOf("*", columnIndex + 1)
      }
    }
    
    return annotatedGrid.map {|row| row.join()}.toList
  }
}
