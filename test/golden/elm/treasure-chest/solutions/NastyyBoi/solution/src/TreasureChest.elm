module TreasureChest exposing (..)

type TreasureChest a = TreasureChest String a 

getTreasure : String -> TreasureChest a -> Maybe a
getTreasure passwordAttempt (TreasureChest pwd t) = if pwd == passwordAttempt then Just t else Nothing            

multiplyTreasure : (a -> List a) -> TreasureChest a -> TreasureChest (List a)
multiplyTreasure multiplier (TreasureChest pwd t) = TreasureChest pwd (multiplier t)
