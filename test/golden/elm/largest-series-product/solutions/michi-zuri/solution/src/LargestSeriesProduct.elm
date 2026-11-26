module LargestSeriesProduct exposing (largestProduct)


largestProduct : Int -> String -> Maybe Int
largestProduct span input =
    List.range 0 (String.length input - span) -- indexes
        |> traverse (getChunkProduct span input) 
        |> Maybe.andThen List.maximum


getChunkProduct : Int -> String -> Int -> Maybe Int 
getChunkProduct span input index = 
    String.left (span + index) input
        |> String.right span -- chunk
        |> String.split ""
        |> traverse String.toInt 
        |> maybeProduct


maybeProduct : Maybe (List Int) -> Maybe Int
maybeProduct maybelist =
    if maybelist == Just [] then
        Nothing
    else 
        Maybe.map List.product maybelist


-- https://github.com/elm-community/maybe-extra/

-- traverse String.toInt ["1","2","a","3"] -> Nothing
-- traverse String.toInt ["1","2","3"] -> Just [1,2,3]
traverse = (\f -> List.foldr (\x -> Maybe.map2 (::) (f x)) (Just []))