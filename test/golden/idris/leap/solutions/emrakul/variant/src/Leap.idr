module Leap

export
isLeap : Int -> Bool
isLeap n = if mod n 400 == 0 then True else if mod n 100 == 0 then False else if mod n 4 /= 0 then True else False

