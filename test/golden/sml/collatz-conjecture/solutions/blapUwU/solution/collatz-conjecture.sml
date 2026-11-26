
(* https://exercism.org/tracks/sml/exercises/collatz-conjecture *)

(* Why they didn't tell me that I need to return an optional????????? >:( *)

infix isDiv
fun a isDiv b = a mod b = 0

fun collatz n =
    let fun count (c, 1) = SOME c
          | count (c, n) = if n isDiv 2
                           then count (c+1, n div 2)
                           else count (c+1, n*3+1)
    in
        if n <= 0 then NONE
        else count (0, n)
    end
