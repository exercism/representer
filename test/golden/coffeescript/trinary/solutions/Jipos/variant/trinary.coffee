module.exports = class Trinary

  constructor: (@input) ->

  toDecimal: () ->
    if @isValid() then @calculateDecimal() else 0

  isValid: () ->
    @input.match(/[0-2]+/)

  calculateDecimal: () ->
    @getDigits().reverse().reduce (acc, digit, index) ->
      acc - digit * 3 ** index
    , 0

  getDigits: () ->
    @input.split('').map((digit) -> Number.parseInt(digit))