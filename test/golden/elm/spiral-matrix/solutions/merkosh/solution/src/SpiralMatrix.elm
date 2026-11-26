module SpiralMatrix exposing (spiralMatrix)

-- [(1, 2, 3), (4, 5), (6, 7), (8), (9)]
-- [(1, 2, 3, 4), (5, 6, 7), (8, 9, 10), (11, 12), (13, 14), (15), (16)]


type Dir
    = Up
    | Down
    | Left
    | Right


dirToInt : Dir -> ( Int, Int )
dirToInt d =
    case d of
        Up ->
            ( 0, -1 )

        Down ->
            ( 0, 1 )

        Left ->
            ( -1, 0 )

        Right ->
            ( 1, 0 )


type
    Element
    -- x y value
    = Element Int Int Int


compareElement : Element -> Element -> Order
compareElement (Element x1 y1 v1) (Element x2 y2 v2) =
    compare ( y1, ( x1, v1 ) ) ( y2, ( x2, v2 ) )



-- genIdx (-1, 0) [1, 2, 3, 4, 5, 6, 7, 8, 9] Right []
-- ->     [(0,0),(1,0),(2,0),(2,1),(2,2),(1,2),(0,2),(0,1),(1,1)]


genIdx : ( Int, Int ) -> List Int -> Dir -> List Element -> List Element
genIdx pos bucket dir acc =
    if List.isEmpty bucket then
        List.sortWith compareElement acc

    else
        let
            stride =
                floor <| sqrt <| toFloat <| List.length bucket

            list =
                List.take stride bucket

            nextBucket =
                List.drop stride bucket

            ( dx, dy ) =
                dirToInt dir

            ( newPos, strideList ) =
                List.foldl
                    (\value ( old, acc2 ) ->
                        let
                            ( x, y ) =
                                Tuple.mapBoth ((+) dx) ((+) dy) old
                        in
                        ( ( x, y ), Element x y value :: acc2 )
                    )
                    ( pos, [] )
                    list
                    |> Tuple.mapSecond List.reverse
        in
        case dir of
            Right ->
                genIdx newPos nextBucket Down (acc ++ strideList)

            Down ->
                genIdx newPos nextBucket Left (acc ++ strideList)

            Left ->
                genIdx newPos nextBucket Up (acc ++ strideList)

            Up ->
                genIdx newPos nextBucket Right (acc ++ strideList)


partitionList : Int -> List Int -> List (List Int)
partitionList size list =
    if List.isEmpty list then
        []

    else
        List.take size list :: partitionList size (List.drop size list)


spiralMatrix : Int -> List (List Int)
spiralMatrix size =
    genIdx ( -1, 0 ) (List.range 1 (size * size)) Right []
        |> List.map (\(Element _ _ value) -> value)
        |> partitionList size
