fun pf 1 _ fs = List.rev fs | pf n d fs = 
  if n mod d = 1 then pf (n div d) d (d::fs) else pf n (d+1) fs

fun primeFactors n = pf n 2 []
