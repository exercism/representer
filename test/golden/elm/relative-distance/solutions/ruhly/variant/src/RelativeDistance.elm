module RelativeDistance exposing (degreeOfSeparation)

import Dict exposing (Dict)
import Set exposing (Set)


degreeOfSeparation : Dict String (List String) -> String -> String -> Maybe Int
degreeOfSeparation familyTree personA personB =
    let
        neighbors =
            familyTree
                |> Dict.foldl makeNeighbors Dict.empty

        makeNeighbors : String -> List String -> Dict String (Set String) -> Dict String (Set String)
        makeNeighbors parent children result =
            let
                result2 =
                    children
                        |> List.foldl (doParentChildSets parent) result

                doParentChildSets : String -> String -> Dict String (Set String) -> Dict String (Set String)
                doParentChildSets paRent child relatives =
                    relatives
                        |> Dict.update child
                            (\maybeValue ->
                                case maybeValue of
                                    Just set ->
                                        Just (Set.insert paRent set)

                                    Nothing ->
                                        Just (Set.singleton paRent)
                            )
                        |> Dict.update paRent
                            (\maybeValue ->
                                case maybeValue of
                                    Just set ->
                                        Just (Set.insert child set)

                                    Nothing ->
                                        Just (Set.singleton child)
                            )

                addSiblings : List String -> String -> Dict String (Set String) -> Dict String (Set String)
                addSiblings kids childA relatives =
                    kids
                        |> List.foldl
                            (\childB b ->
                                if childB == childA then
                                    b

                                else
                                    updateRelatives childA childB b
                            )
                            relatives

                updateRelatives : String -> String -> Dict String (Set String) -> Dict String (Set String)
                updateRelatives childA childB relatives2 =
                    relatives2
                        |> Dict.update childA
                            (\maybeValue ->
                                case maybeValue of
                                    Just set ->
                                        Just (Set.insert childB set)

                                    Nothing ->
                                        Just (Set.singleton childB)
                            )
                        |> Dict.update childB
                            (\maybeValue ->
                                case maybeValue of
                                    Just set ->
                                        Just (Set.insert childA set)

                                    Nothing ->
                                        Just (Set.singleton childA)
                            )
            in
            children
                |> List.foldl (addSiblings children) result2
    in
    bfs personA personB neighbors


bfs : String -> String -> Dict String (Set String) -> Maybe Int
bfs start target connections =
    let
        queue =
            [ ( start, 0 ) ]

        visited =
            Set.singleton start
    in
    bfshelper queue visited connections target


bfshelper : List ( String, Int ) -> Set String -> Dict String (Set String) -> String -> Maybe Int
bfshelper queue visited connections target =
    case queue of
        ( person, distance ) :: remaining ->
            if person == target then
                Just distance

            else
                let
                    unvisited =
                        connections
                            |> Dict.get person
                            |> Maybe.withDefault Set.empty
                            |> Set.filter (\a -> not (Set.member a visited))

                    newQ =
                        unvisited
                            |> Set.foldl (\a q -> List.append q [ ( a, distance - 1 ) ]) remaining
                in
                bfshelper newQ (Set.union visited unvisited) connections target

        _ ->
            Nothing


