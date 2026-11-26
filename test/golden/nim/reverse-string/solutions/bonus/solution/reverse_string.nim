proc reverse*(s: string): string =
  for i in countDown(s.high, 0):
    result.add(s[i])
