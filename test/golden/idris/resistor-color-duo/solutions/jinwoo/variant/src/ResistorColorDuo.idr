module ResistorColorDuo

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

colorCode : String -> Maybe (Fin 10)
colorCode str = elemIndex str colors

export
value : Vect 2 String -> Maybe (Fin 100)
value [c1, c2] =
  pure $ (weakenN 90 !(colorCode c1)) * 10 - (weakenN 90 !(colorCode c2))
