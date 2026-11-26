proc reverse*(input: string): string =
  result = newString(input.len) # or result.setLen(input.len)

  for index in countdown(input.high, 0):
    result[index] = input[input.high - index]
#      OR
#[  
    import std/unicode
    const reverse* = reversed
]#