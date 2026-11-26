proc reverse*(s: string): string =
  result = s
  var
    i = low(s)
    j = high(s)
  while i < j:
    let x = result[i]
    result[i] = result[j]
    result[j] = x
    i.inc
    j.dec
