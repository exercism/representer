module Darts exposing (score)


score : Float -> Float -> Int
score x y =
    let
        dis = sqrt (x * x + y * y)
    in
        if dis <= 1 then
            10
        else if dis <= 5 then
            5
        else if dis <= 10 then
            1
        else
            0
