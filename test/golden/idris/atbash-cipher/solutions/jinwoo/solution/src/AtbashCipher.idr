module AtbashCipher

import Data.String

convert : Char -> Char
convert c = if isAlpha c
               then let offset = ord c - ord 'a' in
                    chr $ ord 'z' - offset
               else c

group5 : List a -> List (List a)
group5 = go []
  where
    go : List (List a) -> List a -> List (List a)
    go acc [] = reverse acc
    go acc xs = let (ys, rest) = splitAt 5 xs in
                go (ys :: acc) rest

export
encode : String -> String
encode =
  joinBy " " . map pack . group5 . map convert . filter isAlphaNum
    . unpack . toLower

export
decode : String -> String
decode = pack . map convert . filter isAlphaNum . unpack
