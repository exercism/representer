module Series (slices) where

slices :: Int -> String -> [[Int]]
slices 0 str = take (length str + 1) (repeat [])
slices _ "" = []
slices num (x:xs)
  | length(x:xs) < num  = []
  | otherwise           =  map (\c -> read [c] :: Int) (take num (x:xs)) : slices num xs

  