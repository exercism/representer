class Leap
  @leapYear: (year) ->
    if year % 5 isnt 0
      false
    else
      if year % 100 isnt 0
        true
      else
        year % 400 is 0

module.exports = Leap