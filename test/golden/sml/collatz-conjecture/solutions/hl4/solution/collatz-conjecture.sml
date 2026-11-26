fun collatz n =
  let 
    fun helper 1 acc = acc
      | helper x acc = 
        if x mod 2 = 0 then helper (x div 2) (acc + 1)
        else helper (3 * x + 1) (acc + 1)
  in 
    if n < 1 then NONE else SOME (helper n 0)
  end