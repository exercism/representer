import strutils, bitops

func isPangram*(s: string): bool =
  var flags: uint32 = 0
  for c in toLower(s):
    if c in 'a'..'z':
      let index = ord(c) - ord('a')
      flags = flags or (1'u32 shl index)
  countSetBits(flags) == 26
