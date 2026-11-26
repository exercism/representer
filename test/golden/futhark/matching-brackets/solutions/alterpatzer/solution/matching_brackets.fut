def opens(c: u8) =
  c == '(' || c == '[' || c == '{'

def closes(c: u8) =
  c == ')' || c == ']' || c == '}'

def closer(c: u8): u8 =
match c
case '(' -> ')'
case '[' -> ']'
case '{' -> '}'
case _ -> assert false '?'

def is_paired (value: []u8): bool =
  let (ok, stack) =
    loop (ok, stack) =
      (true, [])
      for v in value do
        if opens(v)
        then (ok, [closer v] ++ stack)
        else if closes(v) then
         if length stack == 0
           then (false, [])
           else (ok && stack[0] == v, stack[1:])
        else (ok, stack)
  in ok && length stack == 0
