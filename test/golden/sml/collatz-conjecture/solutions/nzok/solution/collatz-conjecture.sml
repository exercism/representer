(* Once again, README lets us down. *)

fun collatz n =
    let fun loop n k = if n = 1 then k else
                       loop (if n mod 2 = 0 then n div 2 else n*3+1) (k+1)
     in if n <= 0 then NONE else SOME (loop n 0)
    end

