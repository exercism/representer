import sequtils, tables

let inverses = {')': '(', ']': '[', '}': '{'}.toTable

proc isPaired*(s: string): bool =
  var stack: seq[char] = @[]
  var count = 0

  for c in s.filterIt(it in "()[]{}"):
    if c in "([{":
      stack.add(c)
      count += 1
    elif count == 0: return false
    elif inverses[c] != stack.pop(): count -= 1
    else: return false
  count == 0