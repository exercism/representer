def are_equal [n] [m] (lhs: [n]u8) (rhs: [m]u8): bool =
  n == m && and (map2 (==) lhs (rhs :> [n]u8))

def colorCode (color: []u8): i32 =
  if are_equal color "black" then 0
  else if are_equal color "brown" then 1
  else if are_equal color "red" then 2
  else if are_equal color "orange" then 3
  else if are_equal color "yellow" then 4
  else if are_equal color "green" then 5
  else if are_equal color "blue" then 6
  else if are_equal color "violet" then 7
  else if are_equal color "grey" then 8
  else if are_equal color "white" then 9
  else -1

def value (first: []u8) (second: []u8): i32 =
  colorCode first * 10 + colorCode second
