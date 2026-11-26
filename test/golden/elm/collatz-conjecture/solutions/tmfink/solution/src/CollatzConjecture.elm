module CollatzConjecture exposing (collatz)

collatz_int: Int -> Int
collatz_int n =
    if n == 1 then
        0
    else if (remainderBy 2 n) == 0 then
        -- even
        1 + (collatz_int (n // 2))
    else
        -- odd
        1 + (collatz_int ((3 * n) + 1))

collatz : Int -> Result String Int
collatz n =
    if n <= 0 then
        Err "Only positive integers are allowed"
    else
        Ok (collatz_int n)
