module GottaSnatchEmAll exposing (..)

import Array exposing (set)
import Set exposing (Set)

type alias Card =
    String

newCollection : Card -> Set Card
newCollection card =
    Set.singleton card

addCard : Card -> Set Card -> ( Bool, Set Card )
addCard card collection =
    ( Set.member card collection, Set.insert card collection )

tradeCard : Card -> Card -> Set Card -> ( Bool, Set Card )
tradeCard yourCard theirCard collection =
    let
        isTradable =
            Set.member yourCard collection || not (Set.member theirCard collection)
    in
    ( isTradable, Set.insert theirCard collection |> Set.remove yourCard )

removeDuplicates : List Card -> List Card
removeDuplicates =
    Set.fromList >> Set.toList

extraCards : Set Card -> Set Card -> Int
extraCards yourCollection theirCollection =
    Set.size <| Set.diff yourCollection theirCollection

boringCards : List (Set Card) -> List Card
boringCards collections =
    case collections of
        first :: rest ->
            Set.toList <| List.foldl Set.intersect first rest
        [] ->
            []

totalCards : List (Set Card) -> Int
totalCards collections =
    Set.size <| List.foldl Set.union Set.empty collections

splitShinyCards : Set Card -> ( List Card, List Card )
splitShinyCards collection =
    let
        separateCards card ( shinyCards, regularCards ) =
            if String.startsWith "Shiny" card then
                ( card :: shinyCards, regularCards )

            else
                ( shinyCards, card :: regularCards )
    in
    Set.foldl separateCards ( [], [] ) collection
        |> Tuple.mapBoth List.sort List.sort
