proc reverse*(str: string): string =
  if str == "": return ""

  var new_str: string
  for i in 0..<str.len:
    new_str.add(str[str.len - 1 - i])
  new_str
