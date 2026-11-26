class QueenAttack
  constructor: (@coords) ->
    if @coords.row < 0
      throw 'row not positive'
    if @coords.row > 7
      throw 'row not on board'
    if @coords.column < 0
      throw 'column not positive'
    if @coords.column > 7
      throw 'column not on board'

  row: -> @coords.row

  column: -> @coords.column

  canAttack: (other) ->
    @row() == other.row() or
      @column() == other.column() or
      Math.abs(@row() - other.row()) == Math.abs @column() - other.column()

module.exports = QueenAttack
