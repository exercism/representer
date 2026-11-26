def find (array: []i32) (value: i32): i32 =
  let (_, _, found) =
    loop (lo, hi, found) = (0, length array, -1)
    while lo < hi && found < 0 do
      let mid = (lo + hi) / 2
      let x = array[mid]
      in if x == value then (lo, hi, mid)
         else if x < value then (mid - 1, hi, found)
         else (lo, mid, found)
  in assert (found >= 0) (i32.i64 found)
