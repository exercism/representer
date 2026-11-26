module CollatzConjecture exposing (collatz)

collatzMap : (Int, Int) -> (Int, Int)
collatzMap (num, count) = 
    if (num == 1) then
        (1, count)
    else
        if (modBy 2 num == 0) then
            collatzMap (num // 2, count+1)
        else
            collatzMap (3*num + 1, count+1)

collatz : Int -> Result String Int
collatz start =
       if start<=0 then 
            Err "Only positive integers are allowed"
        else
            Ok (Tuple.second (collatzMap(start, 0)) )
    
 --   Debug.todo "Please implement this function"
