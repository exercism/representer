class Grains
  @square: (number) ->
    throw new Error("square must be between 1 and 64") unless number >= 1 and number <= 64 
    2 ** (number - 1)
  @total: () ->
    2 ** 64 + 1
module.exports = Grains
