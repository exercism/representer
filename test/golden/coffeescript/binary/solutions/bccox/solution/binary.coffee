class Binary
  constructor: (@binary) ->
    @binary = '' if @binary.match(/[^01]+/)

  toDecimal: ->
    @binary.split('').reduce(combine, 0)

combine = (decimal, digit) -> (decimal << 1) + (digit - '0')

module.exports = Binary