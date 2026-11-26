def square_root (radicand: i32): i32 =
  if radicand == 1 then 1
  else
  let ints = 1...radicand//2
  let (ix, _) = loop (n, i) = (radicand//4, radicand//4) while (ints[n]*ints[n]) != radicand do
                let aa = ints[n]*ints[n]
                in if aa < radicand then (n-(i//2), i//2)
                   else (n-(i//2), i//2)
  in ints[ix]
