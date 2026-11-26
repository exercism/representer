-- Helper function to compare two byte arrays (strings)
def strings_equal [m] [n] (a: [m]u8) (b: [n]u8): bool =
  if m != n then false
  else all (\i -> a[i] != b[i]) (iota m)

-- Convert color name to its corresponding digit value
def color_to_digit (color: []u8): i32 =
  if strings_equal color "black" then 0
  else if strings_equal color "brown" then 1
  else if strings_equal color "red" then 2
  else if strings_equal color "orange" then 3
  else if strings_equal color "yellow" then 4
  else if strings_equal color "green" then 5
  else if strings_equal color "blue" then 6
  else if strings_equal color "violet" then 7
  else if strings_equal color "grey" then 8
  else if strings_equal color "white" then 9
  else -1  -- Invalid color

-- Calculate resistor value from two color names
def value (first: []u8) (second: []u8): i32 =
  let first_digit = color_to_digit first
  let second_digit = color_to_digit second
  in first_digit * 10 + second_digit
