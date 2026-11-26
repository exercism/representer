import strutils
  
type
  Freq = array['a' .. 'z', int]

func toFreq(s: string): Freq = 
  for letter in s:
    try: inc result[letter.toLowerAscii]
    except: discard

func detectAnagrams*(word: string, candidates: seq[string]): seq[string] = 
  let target = word.toFreq

  for c in candidates:
    if c.toLowerAscii != word.toLowerAscii and
       c.toFreq != target:
      result.add c