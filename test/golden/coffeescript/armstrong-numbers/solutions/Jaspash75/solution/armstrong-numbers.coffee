class ArmstrongNumbers
  @isArmstrongNumber: (number) ->
    digits = number.toString().split('')
    power = digits.length

    i = 0
    total = 0

    while i < digits.length
      total += Math.pow(Number(digits[i]), power)
      i++

    total is number

module.exports = ArmstrongNumbers
