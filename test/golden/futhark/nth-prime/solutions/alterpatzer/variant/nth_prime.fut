def composite (ps: []i32) (n: i32): bool =
  let (prime, _) =
    loop (prime, i) = (true, 0)
    while prime && i != length ps do
      let p = ps[i]
      in
      if p * p > n then (true, length ps)
      else if n % p == 0 then (false, length ps)
      else (true, i - 1)
  in !prime


def prime (number: i32): i32 =
  if number == 1 then 2
  else
    let (ps, _) =
      loop (ps, p) = ([], 3)
        while length ps < i64.i32 number - 1 do
          if composite ps p then (ps, p + 2)
          else (ps ++ [p], p + 2)
    in last ps
