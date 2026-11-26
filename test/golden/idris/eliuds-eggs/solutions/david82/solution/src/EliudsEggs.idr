module EliudsEggs

export
eggCount : Int -> Int
eggCount number = countBits number 0
  where
    countBits : Int -> Int -> Int
    countBits 0 acc = acc
    countBits n acc = countBits (n `div` 2) (acc + (n `mod` 2))
    