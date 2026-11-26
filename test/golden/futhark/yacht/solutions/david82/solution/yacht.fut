def score (dice: [5]i32) (category: []u8): i32 =
  let freqs = map (\v -> reduce (+) 0 (map (\x -> if x == v then 1 else 0) dice)) [1,2,3,4,5,6]
  let sum_all = reduce (+) 0 dice
  let non_zero = filter (>0) freqs
  let (len, c0, c1) = (length category, 
                       if length category > 0 then category[0] else 0,
                       if length category > 1 then category[1] else 0)
  
  in match (len, c0, c1)
     -- Number categories: ones through sixes
     case (4, 111, _)   -> freqs[0] * 1  -- "ones"
     case (4, 116, _)   -> freqs[1] * 2  -- "twos"  
     case (6, 116, _)   -> freqs[2] * 3  -- "threes"
     case (5, 102, 111) -> freqs[3] * 4  -- "fours"
     case (5, 102, 105) -> freqs[4] * 5  -- "fives"
     case (5, 115, _)   -> freqs[5] * 6  -- "sixes"
     
     -- Special categories
     case (5, 121, _)    -> if all (==dice[0]) dice then 50 else 0 -- "yacht"
     case (6, 99, _)     -> sum_all -- "choice"
     case (10, 102, 117) -> -- "full house"
       if length non_zero == 2 && any (==3) non_zero && any (==2) non_zero 
       then sum_all else 0
     case (14, 102, 111) -> -- "four of a kind"
       let four_idx = filter (\i -> freqs[i] >= 4) [0,1,2,3,4,5]
       in if length four_idx > 0 then (four_idx[0] + 1) * 4 else 0
     case (15, 108, _)   -> -- "little straight" (1,2,3,4,5)
       if all (\v -> any (==v) dice) [1,2,3,4,5] && length (filter (\v -> any (==v) [1,2,3,4,5]) dice) == 5
       then 30 else 0
     case (12, 98, _)    -> -- "big straight" (2,3,4,5,6)
       if all (\v -> any (==v) dice) [2,3,4,5,6] && length (filter (\v -> any (==v) [2,3,4,5,6]) dice) == 5
       then 30 else 0
     case _              -> 0
