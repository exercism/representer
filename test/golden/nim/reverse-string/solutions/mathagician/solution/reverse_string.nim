proc reverse*(s: string): string =
  let reference = len(s) - 1
  var index = 0
  var ans = ""
  while index < len(s):
    ans.add(s[reference - index])
    index += 1
  return ans
