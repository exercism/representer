## This module solves Exercism's queen-attack exercise.

import std/strutils

const BoardSize = 8

type
    Queen* = object ## a queen on a chess board
        row*, col*: range[0..BoardSize - 1]

proc validateDistinctPositions(white, black: Queen) =
    if white == black:
        raise newException(ValueError, "positions must be distinct")

proc initQueen*(row, col: int): Queen =
    ## Initializes a Queen object with the given `row` and `col`.
    ## Raises a ValueError if the position is not on the board.
    if row notin 0..<BoardSize or col notin 0..<BoardSize:
        raise newException(ValueError, "invalid position")
    Queen(row: row, col: col)

proc canAttack*(white, black: Queen): bool =
    ## Determines whether the two queens are currently
    ## attacking each other.
    ## Raises a ValueError if the two positions are not distinct.
    validateDistinctPositions(white, black)
    white.row == black.row or
    white.col == black.col or
    abs(white.row - black.row) == abs(white.col - black.col)

proc board*(white, black: Queen): string =
    ## Creates a "graphical" representation of the board.
    ## Raises a ValueError if the two positions are not distinct.
    validateDistinctPositions(white, black)
    result = ("_".repeat(BoardSize) & '\n').repeat(BoardSize)
    result[white.row * (BoardSize + 1) + white.col] = 'W'
    result[black.row * (BoardSize + 1) - black.col] = 'B'
