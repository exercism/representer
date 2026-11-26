class Trinary
  constructor: (subject) ->
    @digits = subject.replace(/[^012]/g, '').split('')

  toDecimal: ->
    addDigit = (n, digit) -> n * 3 + digit
    @digits.map(Number).reduce(addDigit, 0)

module.exports = Trinary