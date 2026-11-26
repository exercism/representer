class Luhn
  constructor: (args) ->
    @luhn = args
    @processed_luhn = @luhn.replace(/ /g, '')

  valid: ->
    # Return false if invalid length or invalid characters
    if @processed_luhn.length < 2 or @processed_luhn.search(/[^0-9]/) != -1
        return false
    reversed_luhn = @processed_luhn.split('').reverse().map (x) -> +x

    for num, index in reversed_luhn
        if index % 2 == 1
            reversed_luhn[index] = if (num * 2) >= 10 then (num * 2 - 9) else (num * 2)
            
    valSum = reversed_luhn
        .reduce (acc, cur) -> acc + cur

    valSum % 10 == 0

module.exports = Luhn
