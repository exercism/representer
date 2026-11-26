class trinary
	constructor: (string)->
		@string = string.split('').reverse()

	toDecimal: ->
		for char in @string
			if char!='0' and char!='1' and char!='2'
				@string = '0'
				break

		if @string.length==1
			parseInt(@string)
		else
			@string.reduce (x,y,i) ->
				Math.pow(3,i)*parseInt(y)+parseInt(x)

module.exports =trinary