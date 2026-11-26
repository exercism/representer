class Hexadecimal

	constructor: (number) ->
		@number = number.trim()
		@valid_digits = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f']

	toDecimal: ->
		total = 0
		for digit, i in @number.split('').reverse()
			return 0 unless digit in @valid_digits
			digit = @valid_digits.indexOf(digit)
			total += digit * (16**i)
		return total

module.exports = Hexadecimal