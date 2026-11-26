class Trinary
  constructor : ( @trinary ) ->
    @trinary = '0' if @trinary.match /[^0-2]+/

  toDecimal : () ->
    reversedTrinary = @trinary.split('').reverse()

    decimal = 0
    for number,exponent in reversedTrinary
      decimal += parseInt(number) * Math.pow(3, exponent)

    return decimal

module.exports = Trinary