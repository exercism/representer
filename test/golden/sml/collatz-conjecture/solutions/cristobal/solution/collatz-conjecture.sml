fun collatz(n): int option =
  let
    fun collatz' (1, steps) = steps
      | collatz' (n, steps) = 
        if n mod 2 = 0 then
          collatz'(n div 2, steps + 1)
        else
          collatz'(3 * n + 1, steps + 1)
  in
    (* don't process numbers below 1 *)
    if n < 1 then
      NONE
    (* process postive integer number >= 1 *)
    else
      SOME(
        collatz'(n, 0)
      )
  end
