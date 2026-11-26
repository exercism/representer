def find (array: []i32) (value: i32): i32 =
  let n = i32.i64 (length array)
  let (lo, _) =
    loop (lo, hi) = (-1, n)
    while (hi != lo + 1) do
      let mid = (lo + hi) / 2
      in if array[mid] <= value then (mid, hi) else (lo, mid)
  in
    assert (lo >= 0 && array[lo] == value) lo
