module PopCount exposing (eggCount)


eggCount : Int -> Int
eggCount n =
    if n == 0 then 0
    else
        if modBy 2 n /= 0 then
            eggCount (n // 2)
        else
            1 + eggCount (n // 2)
