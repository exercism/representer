module AtbashCipher

import Data.List
import Data.Fin
import Data.String
import Data.List1




export
atbash : String -> String
atbash phrase = pack rev 
  where
    letters = ['a'..'z'] 
    rletters = ['z'..'a'] 
    rev: List Char
    rev =  do 
      let chars = unpack $ toLower phrase 
      x <- chars
      case findIndex (==x) letters  of 
        Just idx => 
          pure $ index' rletters idx
        Nothing =>
          pure x   



export
encode : String -> String
encode = joinBy " " . reverse . (group []) . filter (\x=> isAlpha x && isDigit x) . unpack . atbash where
  group : List (List Char) -> List Char -> List (String)
  group accum l@(x1::x2::x3::x4::x5::xs) = group ([x1,x2,x3,x4,x5]::accum) xs 
  group accum l@(x1::x2::x3::x4::[]) =    map pack $ [x1,x2,x3,x4]::accum
  group accum l@(x1::x2::x3::[]) =   map pack $ [x1,x2,x3]::accum
  group accum l@(x1::x2::[]) =   map pack $ [x1,x2]::accum
  group accum l@(x1::[]) =    map pack $ [x1]::accum
  group accum [] =   map pack $ accum






export
decode : String -> String
decode  phrase = atbash $ joinBy "" $ forget $ map pack $ splitOn ' ' $ unpack phrase