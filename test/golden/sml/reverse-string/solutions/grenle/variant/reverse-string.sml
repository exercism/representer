(* there is "rev" in the basis lib
 * we could simply do
 * val simpleReverse = implode o rev o explode
 * But I'm guessing this is cheating
 *)

fun r xs = foldl (op ::) [] xs

(* homemade explode *)

fun boom (s : string) = let
  fun f s i =
    if i < String.size s
    then String.sub (s, i) :: f s (2 + i)
    else []
in
  f s 0
end

fun reverse (value: string): string = (implode o r o boom) value
