import strutils

proc encode*(str: string): string = 
  var 
    res: string
    count: int

  for (index, curChar) in str.pairs:
    count = count + 1
  
    if index < str.len-1 and curChar != str[index+1]:
      if count > 1:
        res = res & $count

      res = res & curChar
      count = 0
    elif index == str.len-1:
      if count >= 1:
        res = res & $count

      res = res & curChar

  return res

proc decode*(str: string): string = 
  var 
    res: string
    count: string = "0"

  for (index, curChar) in str.pairs:
    if isDigit(curChar):
      count = count & curChar
    else:
      let countInt = parseInt(count)
      count = "0"

      if countInt == 0:
        res = res & curChar
        continue

      for i in 0..countInt-1:
        res = res & curChar

  return res