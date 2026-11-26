func reverse*(s: string): string =
  result = newString(s.len)
  for i in 0 ..< s.len:
    result[i] = s[s.len - 1 - i]