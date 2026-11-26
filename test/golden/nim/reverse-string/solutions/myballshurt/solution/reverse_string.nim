proc reverse*(str: string): string =
  var
    count = str.len-1
    bufStr: string
  while count > -1:
    bufStr.add(str[count])
    dec count
  return bufStr

echo reverse("eier")