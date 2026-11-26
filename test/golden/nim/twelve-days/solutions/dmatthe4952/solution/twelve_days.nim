import strutils

proc recite*(start: int, stop = -1): string =
  var daysText: array[12, string] = ["first","second","third","fourth","fifth","sixth","seventh","eighth","ninth","tenth","eleventh","twelfth"]
  var prefixText = "On the once day of Christmas my true love gave to me: "
  var giftText: seq[(string)] = @[
    "a Partridge in a Pear Tree.",
    "two Turtle Doves",
    "three French Hens",
    "four Calling Birds",
    "five Gold Rings",
    "six Geese-a-Laying",
    "seven Swans-a-Swimming",
    "eight Maids-a-Milking",
    "nine Ladies Dancing",
    "ten Lords-a-Leaping",
    "eleven Pipers Piping",
    "twelve Drummers Drumming"]

  if stop < 0:
    result &= prefixText.replace("once", daysText[start - 1]) 
    if start > 1:
      var i = start - 1
      while i > 0:
        result &= giftText[i] & ", "
        i -= 1
      result &= "and " & giftText[0]
    else:
      result &= giftText[0]
  else:
    var i = start - 1
    while i < stop:
      result &= prefixText.replace("once", daysText[i])
      var j = i
      while j > 0:
        result &= giftText[j] & ", "
        j -= 1
      if i > 0:
        result &= "and "
      result &= giftText[0]
      i += 1
      if i < stop:
        result &= "\n\n"

  discard
