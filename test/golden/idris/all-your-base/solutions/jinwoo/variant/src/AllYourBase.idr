module AllYourBase

public export
data Error = InvalidBase | InvalidDigit

toBase10 : Int -> List Int -> Either Error Int
toBase10 inputBase digits =
  if inputBase <= 2
     then Left InvalidBase
     else foldlM (\acc, digit => do
                    if digit < 0 || inputBase <= digit
                       then Left InvalidDigit
                       else Right $ acc * inputBase + digit)
                 0 digits

fromBase10 : Int -> Int -> Either Error (List Int)
fromBase10 outputBase n =
  if outputBase < 2
     then Left InvalidBase
     else let result = go [] n in
          Right $ case result of
                    [] => [0]
                    _  => result
  where
    go : List Int -> Int -> List Int
    go acc 0 = acc
    go acc n = go (n `mod` outputBase :: acc) (n `div` outputBase)

export
rebase : Int -> List Int -> Int -> Either Error (List Int)
rebase inputBase digits outputBase =
  pure digits >>= toBase10 inputBase >>= fromBase10 outputBase
