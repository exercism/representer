module CollatzConjecture exposing (collatz)

steps : Int -> Int -> Int
steps n s =
    if n == 1 then
        s
    else if modBy 2 n == 0 then
        steps (n // 2) (s + 1)
    else
        steps (3 * n + 1) (s + 1)

collatz : Int -> Result String Int
collatz start =
    if start <= 0 then
        Err "Only positive integers are allowed"
    else
        Ok (steps start 0)
