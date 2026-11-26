class Luhn
  constructor: (@number) ->

  valid: ->
    # Remove spaces from the number
    number = @number.replace(/\s/g, '')

    # Check if the number is valid
    if number.length <= 1 or not /^[0-9]+$/.test(number)
      return false

    # Reverse the number and convert it to an array of digits
    digits = number.split('').reverse().map(Number)

    # Double every second digit and subtract 9 if the result is greater than 9
    for i in [1...digits.length] by 2
      digits[i] *= 2
      digits[i] -= 9 if digits[i] > 9

    # Sum all the digits and check if the sum is divisible by 10
    sum = digits.reduce((a, b) -> a + b)
    sum % 10 == 0

module.exports = Luhn