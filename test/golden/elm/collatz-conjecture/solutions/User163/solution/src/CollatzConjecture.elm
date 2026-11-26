module CollatzConjecture exposing (collatz)


collatz : Int -> Result String Int
collatz start =
    if (start >0) then
        Ok (coll start 0)
    else 
        Err ("Only positive integers are allowed")




coll : Int -> Int -> Int
coll start count =
    if (start == 1) then
        count
    else if ((modBy 2 start) == 0) then
        coll (start//2) (count+1)
    else
        coll(start*3+1) (count+1)