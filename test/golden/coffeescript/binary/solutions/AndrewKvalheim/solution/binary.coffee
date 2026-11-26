module.exports =
class NumeralSystem
  # Default to binary.
  symbols: '01'

  # Initialize from a reference numeral.
  constructor: (@numeral) ->
    @radix = @symbols.length

  # Generate an array containing the decimal value of each digit of the
  # reference numeral in little-endian order, empty if the numeral is invalid.
  digits: ->
    @_digits ?= do =>
      return [] unless @isValid()

      @symbols.indexOf(symbol) for symbol in @numeral.split('') by -1

  # Whether the reference numeral is valid in this number system
  isValid: ->
    @_isValid ?= ///^[#{ @symbols }]+$///.test(@numeral)

  # Calculate the decimal value of the reference numeral.
  toDecimal: ->
    @_toDecimal ?= @digits().reduce (decimal, digit, position) =>
      decimal += digit * Math.pow(@radix, position)
    , 0