import sequtils, strutils

func clean*(phone:string): string =
  var inp = filterIt(phone, it in Digits) # remove non-digits
  if inp.len notin 10 .. 11:
    raise newException(ValueError, "Bad length!!")
  if inp.len == 11:
    if inp[0] != '1':
      raise newException(ValueError, "Bad first digit!!")
    else:
      inp = inp[1..<inp.len]
  if inp[0] < '2':
    raise newException(ValueError, "Bad area code!!")
  if inp[3] < '2':
    raise newException(ValueError, "Bad exchange code!!")
  for s in inp: result &= s
