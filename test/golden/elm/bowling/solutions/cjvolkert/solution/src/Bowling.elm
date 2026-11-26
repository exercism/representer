module Bowling exposing (Rolls, score)

import Parser exposing (Trailing(..))


type alias Rolls =
    List Int


group : Rolls -> List (Maybe (List Int))
group rolls =
    case rolls of
        10 :: x :: y :: [] ->
            [ build_strike 10 x y ]

        t1 :: t2 :: y :: [] ->
            [ build_spare t1 t2 y ]

        t1 :: t2 :: [] ->
            if t1 + t2 == 10 then
                [ Nothing ]

            else
                [ build_open t1 t2 ]

        10 :: x :: y :: tail ->
            build_strike 10 x y :: group (x :: y :: tail)

        t1 :: t2 :: y :: tail ->
            if t1 + t2 == 10 then
                build_spare t1 t2 y :: group (y :: tail)

            else if t1 + t2 < 10 then
                build_open t1 t2 :: group (y :: tail)

            else
                []

        _ ->
            []


build_open : Int -> Int -> Maybe (List Int)
build_open x y =
    if x > 10 || y > 10 || x + y > 10 then
        Nothing

    else
        Just [ x, y ]


build_strike : Int -> Int -> Int -> Maybe (List Int)
build_strike x y z =
    if x > 10 || y > 10 || z > 10 then
        Nothing

    else if y < 10 && (y + z) > 10 then
        Nothing

    else
        Just [ x, y, z ]


build_spare : Int -> Int -> Int -> Maybe (List Int)
build_spare x y z =
    if x + y /= 10 || x > 10 || y > 10 || z > 10 then
        Nothing

    else
        Just [ x, y, z ]


score : Rolls -> Maybe Int
score rolls =
    let
        grouped =
            group rolls
    in
    if List.length grouped /= 10 then
        Nothing

    else if grouped |> List.any (\t -> t == Maybe.Nothing) then
        Nothing

    else
        Just (grouped |> List.filterMap identity |> List.map List.sum |> List.sum)
