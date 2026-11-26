module Say (inEnglish) where

inEnglish v
  | v == 0 = Just "zero"
  | v < 0 = Nothing
  | otherwise = Just . unwords . inEnglish' postfix $ v

postfix = ["", "thousand", "million", "billion", "trillion", "quadrillion"]

inEnglish' px v
  | null px = []
  | v == 0 = []
  | otherwise = thousand ++ (filter (not . null) [hundred, ten, post])
  where
    (n, nr) = v `divMod` 1000
    (h, hr) = nr `divMod` 100
    (t, tr) = hr `divMod` 10
    (p:ps) = px
    hundred = if h > 0 then getUnder20 h ++ " hundred" else ""
    ten = if t < 2 then getUnder20 hr else getOver20 t tr
    post = if nr == 0 then "" else p
    thousand = inEnglish' ps n

under20 = ["", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
getUnder20 n = head . drop n $ under20

over20 = ["", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]
getOver20 t tr = let
    ten = head . drop (t - 1) $ over20
    one = getUnder20 tr
  in ten ++ (if tr > 0 then "-" ++ one else "")