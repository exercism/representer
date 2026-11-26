class Minesweeper
  @annotate: (minefield) ->
    # Handle empty input
    return [] if minefield.length == 0
    
    numRows = minefield.length
    numColumns = minefield[0].length
    
    # Create result array
    annotatedBoard = for rowIndex in [0...numRows]
      for colIndex in [0...numColumns]
        ' '
        
    # Directions for adjacent squares
    adjacentDirections = [
      [-1, -1], [-1, 0], [-1, 1],  # top-left, top, top-right
      [0, -1],          [0, 1],     # left, right
      [1, -1],  [1, 0], [1, 1]      # bottom-left, bottom, bottom-right
    ]
    
    # Count mines around a position
    countAdjacentMines = (currentRow, currentCol) ->
      mineCount = 0
      for [rowOffset, colOffset] in adjacentDirections
        neighborRow = currentRow + rowOffset
        neighborCol = currentCol + colOffset
        if 0 <= neighborRow < numRows and 0 <= neighborCol < numColumns and minefield[neighborRow][neighborCol] == '*'
          mineCount++
      mineCount
    
    # Process each cell
    for rowIndex in [0...numRows]
      for colIndex in [0...numColumns]
        if minefield[rowIndex][colIndex] == '*'
          annotatedBoard[rowIndex][colIndex] = '*'
        else
          adjacentMines = countAdjacentMines(rowIndex, colIndex)
          annotatedBoard[rowIndex][colIndex] = if adjacentMines > 0 then adjacentMines.toString() else ' '
    
    # Convert result to strings
    annotatedBoard.map (row) -> row.join('')

module.exports = Minesweeper
