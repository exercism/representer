proc reverse*(s: string): string =
  for char in s:
    result = char & result
