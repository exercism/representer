import tables, strutils, sequtils

const tableTill20 = {0: "", 1: "one", 2: "two", 3: "three", 4: "four", 5: "five", 6: "six", 7: "seven", 8: "eight", 9: "nine", 10: "ten", 11: "eleven", 12: "twelve", 13: "thirteen", 14: "fourteen", 15: "fifteen", 16: "sixteen", 17: "seventeen", 18: "eighteen", 19: "nineteen"}.toTable()
const tableMultOf10 = {2: "twenty", 3: "thirty", 4: "forty", 5: "fifty", 6: "sixty", 7: "seventy", 8: "eighty", 9: "ninety"}.toTable()

func sayTwoDigits(n: int): string =
  if 0 < n and n < 20: return tableTill20[n]
  elif n <= 99:
    if n mod 10 == 0: return tableMultOf10[n div 10]
    else: return tableMultOf10[n div 10] & "-" & tableTill20[n mod 10]

func sayThreeDigits(n: int): string =
  if n div 100 > 0:
    result.add(tableTill20[n div 100] & " hundred")
    if n mod 100 > 0: result.add(" ")
  result.add(sayTwoDigits(n mod 100))

func split3digits(n: int): seq[int] =
  var n = n
  for i in 0..3:
    result.add(n mod 1000)
    n = n div 1000

proc say*(n: int64): string =
  if n notin 0..999_999_999_999: raise newException(ValueError, "invalid input")
  if n == 0: return "zero"
  let split = split3digits(n)
  var resultSeq: seq[string] = @[]
  if split[3] > 0: resultSeq.add(sayThreeDigits(split[3]) & " billion")
  if split[2] > 0: resultSeq.add(sayThreeDigits(split[2]) & " million")
  if split[1] > 0: resultSeq.add(sayThreeDigits(split[1]) & " thousand")
  if split[0] > 0: resultSeq.add(sayThreeDigits(split[0]))
  resultSeq.join(" ")