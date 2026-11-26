use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide: matrix end

fun matrix(inputString :: String) -> Object:
  matrixList = inputString
        ^ string-split-all(_, "\n")
        ^ map(
            lam(rowString):
              rowString
              ^ string-split-all(_, " ")
              ^ map({(numberString): string-to-number(numberString).value}, _)
            end, _)

  # Return an object representing the matrix with methods to access rows and columns
  {
    matrix: matrixList,
    
    method row(self, rowIndex) -> List:
      # Safely access a row with error handling for out-of-bounds indexes
      if (rowIndex > 0) and (rowIndex <= self.matrix.length()):
        self.matrix.get(rowIndex - 1)
      else:
        raise("Row index out of bounds: " + tostring(rowIndex))
      end
    end,
    
    method column(self, columnIndex) -> List:
      # Compute a column by iterating over rows, with error checking for column bounds
      if (columnIndex <= 0) or (columnIndex > self.matrix.get(0).length()):
        raise("Column index out of bounds: " + tostring(columnIndex))
      else:
        range(0, self.matrix.length())
        ^ map(lam(rowIndex): self.matrix.get(rowIndex).get(columnIndex - 1) end, _)
      end
    end
  }
end
