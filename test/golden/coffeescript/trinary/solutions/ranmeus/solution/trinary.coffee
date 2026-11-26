class Trinary
	
	constructor: (str) ->
		@_dec = 0
		for c in str
			if -1 is tri = "012".indexOf c
				@_dec = 0
				break
			@_dec = (@_dec * 3) + tri

	toDecimal: -> @_dec
		
module.exports = Trinary