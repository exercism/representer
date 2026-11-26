class QueensAttack
  constructor: (queen) ->
    throw('row not positive') if queen.row < 0
    throw('row not on board') if queen.row > 7
    throw('column not positive') if queen.column <= 0
    throw('column not on board') if queen.column > 7
    @row = queen.row
    @column = queen.column

  canAttack: (otherQueen) ->
    return (@row is otherQueen.row or
        @column is otherQueen.column or
        Math.abs(@row - otherQueen.row) is Math.abs(
            @column - otherQueen.column))

module.exports = QueensAttack
