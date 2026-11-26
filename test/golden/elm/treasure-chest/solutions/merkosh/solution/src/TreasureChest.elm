module TreasureChest exposing (..)


type TreasureChest a
    = TreasureChest String a


getTreasure : String -> TreasureChest a -> Maybe a
getTreasure passwordAttempt (TreasureChest pwd x) =
    if pwd == passwordAttempt then
        Just x
    else
        Nothing


multiplyTreasure : (a -> List a) -> TreasureChest a -> TreasureChest (List a)
multiplyTreasure multiplier (TreasureChest pwd x) =
    TreasureChest pwd (multiplier x)
