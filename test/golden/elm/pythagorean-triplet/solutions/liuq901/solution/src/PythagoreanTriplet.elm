module PythagoreanTriplet exposing (triplets)


type alias Triplet =
    ( Int, Int, Int )


gcd : Int -> Int -> Int
gcd x y =
    if y == 0 then x else gcd y (modBy y x)


generate : Int -> ( Int, Int ) -> Maybe Triplet
generate sum ( n, m ) =
    let
        a = m * m - n * n
        b = 2 * m * n
        c = m * m + n * n
        scale = sum // (a + b + c)
    in
        if gcd n m /= 1 || modBy 2 n == modBy 2 m || modBy (a + b + c) sum /= 0 then
            Nothing
        else
            [a * scale, b * scale, c * scale]
                |> List.sort
                |> (\x -> 
                    case x of
                        [ aa, bb, cc] -> Just ( aa, bb, cc )
                        _ -> Nothing)


triplets : Int -> List Triplet
triplets n =
    let
        intSqrt x = x |> toFloat |> sqrt |> round
    in
        List.range 1 (intSqrt n)
            |> List.map (\x -> ( x, List.range (x + 1) (intSqrt n) ))
            |> List.foldl (\( x, ys ) acc -> acc ++ List.map (\y -> ( x, y )) ys) []
            |> List.map (generate n)
            |> List.filter (\x -> x /= Nothing)
            |> List.map (Maybe.withDefault ( 0, 0, 0 ))
            |> List.sort
