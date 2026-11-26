module TreasureFactory exposing (TreasureChest, getTreasure, makeChest, makeTreasureChest, secureChest, uniqueTreasures)

import Set


type TreasureChest treasure
    = TreasureChest String treasure


getTreasure : String -> TreasureChest a -> Maybe a
getTreasure passwordAttempt (TreasureChest password treasure) =
    if passwordAttempt == password then
        Just treasure

    else
        Nothing


type Chest treasure conditions
    = Chest treasure String


makeChest : String -> treasure -> Chest treasure {}
makeChest password treasure =
    Chest treasure password


secureChest : Chest treasure conditions -> Maybe (Chest treasure { conditions | securePassword : () })
secureChest (Chest treasure password) =
    if String.length password > 8 then
        Just (Chest treasure password)

    else
        Nothing


uniqueTreasures : List (Chest treasure conditions) -> List (Chest treasure { conditions | uniqueTreasure : () })
uniqueTreasures chests =
    let
        ( _, doubles ) =
            List.foldl
                (\(Chest treasure _) ( all, duplicates ) ->
                    let
                        comparableTreasure =
                            Debug.toString treasure
                    in
                    if Set.member comparableTreasure all then
                        ( all, Set.insert comparableTreasure duplicates )

                    else
                        ( Set.insert comparableTreasure all, duplicates )
                )
                ( Set.empty, Set.empty )
                chests

        isDuplicate (Chest treasure _) =
            Set.member (Debug.toString treasure) doubles
    in
    List.filter (not << isDuplicate) chests |> List.map (\(Chest treasure password) -> Chest treasure password)


makeTreasureChest : Chest treasure { conditions | securePassword : (), uniqueTreasure : () } -> TreasureChest treasure
makeTreasureChest (Chest treasure password) =
    TreasureChest password treasure
