-- Return the list as-is.
def scores (values: []i32): []i32 = values

-- Return the last added score.
def latest (values: []i32): i32 =
  let n = length values
  in values[n-1]

-- Simple integer max helper (avoids any ambiguity about overloading).
def imax (a: i32) (b: i32): i32 = if a > b then a else b

-- Return the single best (maximum) score.
def personal_best (values: []i32): i32 =
  let h = values[0]
  in reduce imax h values[1:]

-- Return the top three scores in descending order.
-- (Assumes there are at least three scores, as in the tests.)
def personal_top_three (values: []i32): [3]i32 =
  let (t1, t2, t3) =
    loop (t1, t2, t3) = (-1i32, -1i32, -1i32) for x in values do
      if x >= t1 then (x, t1, t2)
      else if x >= t2 then (t1, x, t2)
      else if x >= t3 then (t1, t2, x)
      else (t1, t2, t3)
  in [t1, t2, t3]
    