func reverse*(s: string): string =
  for i in countdown(s.high, s.low):
    result.add(s[i])
