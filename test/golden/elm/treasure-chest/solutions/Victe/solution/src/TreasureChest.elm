module TreasureChest exposing (..)


type TreasureChest a
    = TreasureChest String a


getTreasure : String -> TreasureChest a -> Maybe a
getTreasure passwordAttempt (TreasureChest storedPass theTreasure) =
    if passwordAttempt == storedPass then
        Just theTreasure

    else
        Nothing


multiplyTreasure : (a -> List a) -> TreasureChest a -> TreasureChest (List a)
multiplyTreasure multiplier (TreasureChest pass theTreasure) =
    TreasureChest pass (multiplier theTreasure)
