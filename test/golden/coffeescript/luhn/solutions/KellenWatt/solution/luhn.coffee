isDigit = (c) ->
    code = c.charCodeAt(0)
    48 <= code <= 57

class Luhn
  constructor: (args) ->
    @digits = args.split("").filter((c) -> c != " ").reverse()

  valid: ->
    return false unless @digits.length > 1
    @digits = @digits.map((d) -> Number(d))
    return false if @digits.some((d) -> Number.isNaN(d))

    total = @digits.reduce(((sum, d, i) -> 
                    if i % 2 == 1
                        d *= 2
                        if d > 9
                            d -= 9
                    sum + d
                    ), 0)
    
    total % 10 == 0
     
    

module.exports = Luhn
