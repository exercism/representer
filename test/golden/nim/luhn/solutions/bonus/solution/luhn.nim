import strutils, sequtils, algorithm


proc isValid*(s: string): bool =
  if s.strip.len < 2:
    return false
  var number = reversed(s).join
  if number.split.join != number.filterIt(it.isDigit).join:
    return false
  let digits = number.filterIt(it.isDigit).mapIt(parseInt($it))
  var sum_of = 0
  for i in 0..<digits.len:
    var num = digits[i]
    if i mod 2 == 1:
      let doubled = num * 2
      num = if doubled > 9: doubled - 9 else: doubled
    sum_of += num
  if sum_of mod 10 == 0:
    return true
  return false

if isMainModule:
  let s = "0000 0"
  echo isValid(s)

