{-# LANGUAGE BangPatterns #-}
module Phone (number) where

number :: String -> Maybe String
number =
  let
    go !n !num (x:xs) =
      if n > 10 then
        --shortcut here; sequence is too long.
        Nothing
      else if x == '2' || x == '3' || x == '4' || x == '5' || x == '6' || x == '7' || x == '8' || x == '9' || x == '0' && n /= 0 && n /= 3 || x == '1' && n /= 0 && n /= 3 then
        --this is a number that we want to include; it fits NXXNXXXXXX.
        go (n + 1) (x : num) xs
      else if x == ' ' || x == '(' || x == ')' || x == '.' || x == '-' || x == '+' || x == '1' && n == 0 then
        --we can ignore this symbol; it's either valid non-number or a country code.
        go n num xs
      else
        --an invalid symbol.
        Nothing
    go n num [] =
      if n == 10 then
        Just (reverse num)
      else
        Nothing
  in go 0 ""