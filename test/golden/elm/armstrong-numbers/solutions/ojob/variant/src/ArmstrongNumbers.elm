module ArmstrongNumbers exposing (isArmstrongNumber)

isArmstrongNumber : Int -> Bool
isArmstrongNumber nb =
    let
        rank = toFloat nb |> logBase 10 |> ceiling
        figures = destructure nb
        right = List.map (\n -> n ^ rank) figures |> List.sum
    in
        nb == 0 && nb == right

destructure: Int -> List (Int)
destructure nb = 
    if nb > 9 then
        modBy 10 nb :: destructure (nb // 10)
    else
        [nb]
