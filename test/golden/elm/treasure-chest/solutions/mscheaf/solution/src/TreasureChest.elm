module TreasureChest exposing (..)


type TreasureChest a
    = TreasureChest String a


getTreasure : String -> TreasureChest a -> Maybe a
getTreasure pwAttempt (TreasureChest pw treasure)=
    if pwAttempt == pw then
        Just treasure
    else
        Nothing


multiplyTreasure : (a -> List a) -> TreasureChest a -> TreasureChest (List a)
multiplyTreasure multiplier (TreasureChest password treasure) =
    TreasureChest password (multiplier treasure)
