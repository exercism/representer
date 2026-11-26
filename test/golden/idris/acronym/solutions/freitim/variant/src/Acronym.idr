module Acronym

export
abbreviate : String -> String
abbreviate = pack . go Lin True . unpack
    where go : SnocList Char -> Bool -> List Char -> List Char
          go sx _   []        = sx <>> Nil
          go sx pws (x :: xs) = case (pws || isAlpha x, pws || any (x ==) [' ', '-']) of
              (True,  True) => go (sx :< (toUpper x)) False xs
              (False, True) => go sx True xs
              (_,     _)    => go sx False xs