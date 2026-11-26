module ResistorColorTrio

import Data.String
import Data.Vect

colors : Vect 10 String
colors = [ "black"
         , "brown"
         , "red"
         , "orange"
         , "yellow"
         , "green"
         , "blue"
         , "violet"
         , "grey"
         , "white"
         ]

colorCode : String -> Maybe Nat
colorCode str = pure $ cast !(elemIndex str colors)

isInt : Double -> Bool
isInt val = val - cast n == 0.0
  where
    n : Int
    n = cast val

withUnit : Nat -> String
withUnit val =
  if val >= 1_000_000_000 then
    "\{showNum (cast val / 1.0e9)} gigaohms"
  else if val >= 1_000_000 then
    "\{showNum (cast val / 1.0e6)} megaohms"
  else if val > 1_000 then
    "\{showNum (cast val / 1.0e3)} kiloohms"
  else
    "\{show val} ohms"

  where
    showNum : Double -> String
    showNum val =
      if isInt val then show (the Int (cast val)) else show val

export
label : Vect 3 String -> Maybe String
label [c1, c2, c3] = do
  n1 <- colorCode c1
  n2 <- colorCode c2
  n3 <- colorCode c3
  let val := (n1 * 10 + n2) * (power 10 n3)
  pure $ withUnit val
