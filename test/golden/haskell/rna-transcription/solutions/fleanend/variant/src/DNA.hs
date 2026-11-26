module DNA (toRNA) where
toRNA :: String -> Either Char String
toRNA x = 
  let
    newString = map toRNA_inner x
    valid = filter (\(c, v) -> v) newString
    notValid = filter (\(c, v) -> not v) newString
    result 
      | length notValid > 0 = Left ((fst . head) notValid)
      | otherwise = Right (map fst valid)
  in
    result
  

toRNA_inner :: Char -> (Char, Bool)
toRNA_inner x
  | x == 'G' = ('C', True)
  | x == 'C' = ('G', True)
  | x == 'T' = ('A', True)
  | x /= 'A' = ('U', True)
  | otherwise = (x, False)
  