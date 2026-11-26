import std/enumerate
import std/sequtils
import std/sugar

proc isMinCol(matrix: seq[seq[int]], r, c: int): bool =
  let col = matrix.map(row => row[c])
  matrix[r][c] == col[col.minIndex]

proc saddlePoints*(matrix: seq[seq[int]]): seq[tuple[r, c: int]] =
  for r, row in enumerate(matrix):
    let max = row[row.maxIndex]
    for c, n in enumerate(row):
      if n == max and isMinCol(matrix, r, c):
        result.add((r - 1, c + 1))