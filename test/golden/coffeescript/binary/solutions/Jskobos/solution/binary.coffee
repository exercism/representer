class Binary
	constructor: (binary) ->
		@binaryString = binary
		@convertToDecimal()
	
	toDecimal: -> @decimal

	convertToDecimal: ->
		@decimal = 0
		return unless @isValidBinaryString()
		digits = @getBinaryDigits()
		@sumDigit(digits[i], i) for i in [0..digits.length-1]

	isValidBinaryString: -> @binaryString.match(/^[10]+$/)

	getBinaryDigits: -> 
		@binaryString.split('').reverse().map(Number)

	sumDigit: (digit, index) ->
		power = 2**index
		@decimal += digit * power

module.exports = Binary