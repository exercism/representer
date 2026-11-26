def ix(p: i32): i64 =
  i64.i32 ((p - 3) / 2)

def primes (limit: i32): []i32 = 
  if limit < 2 then []
  else
    let istop = 1 + ix limit
    let (ps, _, _) = loop (ps, p, crossed_out) =
      ([2], 3, replicate istop false)
      while p <= limit do
        if crossed_out[ix p] then
          (ps, p + 2, crossed_out)
        else
          let updated =
            if p * p > limit then crossed_out
            else
              let i0 = ix (p * p)
              let ncross = 1 + (istop - i0) / i64.i32 p
              let is = tabulate ncross (\i -> i0 + i64.i32 p * i)
              let ts = replicate ncross true
              in scatter crossed_out is ts
          in (ps ++ [p], p + 2, updated)
    in ps
