def square_root (radicand: i32): i32 = 
  let (_,_,result) = loop (low, high, result) = (1, radicand, 1) while low <= high do
                       let mid = (low + high) / 2
                       let square = mid * mid
                       in if square == radicand 
                          then (mid, mid-1, mid)  -- found exact match, exit loop
                          else if square < radicand 
                          then (mid + 1, high, mid)  -- search upper half
                          else (low, mid - 1, result)  -- search lower half
  in result
  