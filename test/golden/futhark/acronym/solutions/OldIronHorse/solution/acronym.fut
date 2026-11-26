def to_uppercase (c: u8): u8 =
  if c >= 'a' && c <= 'z'
    then c - 'a' + 'A'
    else c

def abbreviate (phrase: []u8): []u8 =
  let cs = " " ++ phrase in
    cs
    |> rotate 1
    |> zip cs
    |> filter (\(p, c) ->  (any (\s -> s == p) " -_") && (all (\s -> s != c) " -_"))
    |> map (\(_, c) -> c)
    |> map to_uppercase
