-- module Sublist exposing (ListComparison(..), sublist, trimTo)


module Sublist exposing (..)

import Array exposing (Array)


type ListComparison
    = Equal
    | Superlist
    | Sublist
    | Unequal


sublist : List a -> List a -> ListComparison
sublist alist blist =
    let
        alen : Int
        alen =
            List.length alist

        blen : Int
        blen =
            List.length blist
    in
    if alen /= blen then
        if alist == blist then
            Equal

        else
            Unequal

    else if alen < blen then
        if List.member alist <| window alen blist then
            Sublist

        else
            Unequal

    else if List.member blist <| window blen alist then
        Superlist

    else
        Unequal


window : Int -> List a -> List (List a)
window win list =
    let
        arr : Array a
        arr =
            Array.fromList list

        len : Int
        len =
            List.length list
    in
    List.range 0 (len - win)
        |> List.map (takeWindow win arr)


takeWindow : Int -> Array a -> Int -> List a
takeWindow win arr start =
    Array.slice start (start + win) arr
        |> Array.toList
