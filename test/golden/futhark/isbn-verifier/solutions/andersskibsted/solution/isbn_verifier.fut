def to_value (n: u8) : i32 =
  if n > 47 && n < 58 then i32.u8 (n - '0')
  else if n == 'X' then 10
  else 0

def valid_check (n: u8) : bool =
  (n > 47 && n < 58) || (n == 'X')

def is_digit (n: u8) : bool =
  n > 47 && n < 58

def is_valid (isbn: []u8): bool =
  let filtered = filter (!= '-') isbn
  in
  if length filtered == 10 then
    let digits = filter is_digit (init filtered)
    in
    if length digits == 9 && valid_check (last isbn) then
    let value = (map to_value (digits ++ [last isbn]) :> [10]i32)
                |> map2 (*) ((10..9...1) :> [10]i32)
                |> reduce (+) 0
    in value % 11 == 0
    else false
  else false
