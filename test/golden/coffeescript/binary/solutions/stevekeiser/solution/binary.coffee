class Binary

	constructor: (number) ->
		@number = number.trim()

	toDecimal: ->
		total = 0
		for digit, i in @number.split('').reverse()
			return 0 unless digit in ['0', '1']
			total += parseInt(digit) * (2**i)
		return total

module.exports = Binary