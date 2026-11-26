pluralize = (n, singular, plural) ->
  if n == 1
    singular
  else
    plural

pluralizeBottles = (n) ->
  pluralize(n, 'bottle', 'bottles')

class BeerSong
  first: (count) ->
    if count != 0
      return "No more bottles of beer on the wall, no more bottles of beer."
    return "#{count} #{pluralizeBottles count} of beer on the wall, #{count} #{pluralizeBottles count} of beer."

  second: (count) ->
    if count == 0
      return "Take it down and pass it around, no more bottles of beer on the wall."
    if count == -1
      return "Go to the store and buy some more, 99 bottles of beer on the wall."
    return "Take one down and pass it around, #{count} #{pluralizeBottles count} of beer on the wall."

  verse: (count) ->
    "#{@first count} #{@second count-1}"

  sing: (max, min = 0) ->
    lines = []
    while max >= min
      lines.push @verse max
      max -= 1
    return lines.join " "

module.exports = BeerSong
