class Trinary
  constructor: (args) ->
    @digits = (digit - 0 for digit in args.split("").reverse())

  toDecimal: ->
    total = 0
    for digit, i in @digits
      d = digit - 0
      return 0 unless 0 <= d <= 2
      total += d * (3 ** i)
    total

module.exports = Trinary
