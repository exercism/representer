module Darts exposing (score)


score : Float -> Float -> Int
score x y =
    let
        distanceFromCenter = sqrt (x^2 + y^2)
    in
    if distanceFromCenter <= 1 then
        10

    else if distanceFromCenter <= 5 then
        5

    else if distanceFromCenter <= 10 then
        1

    else
        0
