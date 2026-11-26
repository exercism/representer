module CollatzConjecture exposing (collatz)


collatz : Int -> Result String Int

collatz start =
    let
        recursion number counter =
            if (round number) == 1 then
                counter |> Ok
            else if (modBy 2 (round number)) == 0 then
                recursion ( number / 2) (counter + 1)   
            else 
                recursion ((number * 3) + 1) (counter + 1)
        floatStart = toFloat start
    in 
    if start <= 0 then
        Err "Only positive integers are allowed"
    else 
        recursion floatStart 0