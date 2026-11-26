module CollatzConjecture

export
steps : Int -> Maybe Int
steps number = case (number <= 1) of
    True => Nothing
    False => Just (go 0 number)
  where
    go : Int -> Int -> Int
    go step 1 = step
    go step num = case (mod num 2) of
      0 => go (step + 1) (div num 2)
      _ => go (step + 1) (3 * num + 1)
