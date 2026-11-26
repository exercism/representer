class Trinary
  constructor: (number) ->
    @trinary_number = number.replace(/[^012]/g,'')

  toDecimal: ->
    total = 0
    for number, pow in @trinary_number.split('').reverse()
      total += parseInt(number) * Math.pow(3,pow)
    total

module.exports = Trinary