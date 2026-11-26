class Hexadecimal
  constructor: (@raw) ->

  toDecimal: ->
    result = 0
    @raw = @raw.toLowerCase().trim()
    invalidHex = @raw.search(/[^0-9a-f]/) != -1
    result = parseInt(@raw, 16) if !invalidHex
    return result

module.exports = Hexadecimal