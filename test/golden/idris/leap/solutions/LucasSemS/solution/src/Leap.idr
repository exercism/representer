module Leap

-- Torna a função pública
public export
isLeap : Int -> Bool
isLeap year = (year `mod` 4 == 0) && ((year `mod` 100 /= 0) || (year `mod` 400 == 0))
