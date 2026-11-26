# This is a stub file for the CoffeeScript track
class Hexadecimal
  constructor: (args) ->
    @hex = args

  toDecimal:  ->
    return 0 unless @hex.match /[0-9a-fA-F]$/
    parseInt @hex, 16

module.exports = Hexadecimal
