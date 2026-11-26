module EliudsEggs exposing (eggCount)


eggCount : Int -> Int
eggCount n =
    if n == 0
        then
            0
        else
            (modBy 2 n) + eggCount (n // 2)