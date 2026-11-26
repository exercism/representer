import sequtils,strutils
  
proc reverse*(a: string): string =
  var temp: seq[char] = @[]
  for i,v in a.pairs:
    temp.insert(v, 0)
  temp.join()