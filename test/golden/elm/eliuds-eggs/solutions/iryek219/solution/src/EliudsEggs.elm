module EliudsEggs exposing (eggCount)


eggCount : Int -> Int
eggCount n =
    case (n//2, modBy 2 n) of
        (0, m) -> m
        (d, m) -> m + (eggCount d)
