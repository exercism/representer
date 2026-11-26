def to_string (number: i32): []u8 =
  let (_, ss) =
   loop (n, s) = (number, "") while n > 0 do
     (n // 10, ['0' + (u8.i32 (n % 10))] ++ s)
  in ss

def suffix (number: i32): []u8 =
  let units = number % 10
  let tens = number % 100
  in
    if units == 1 && tens != 11 then "st"
    else if units == 2 && tens != 12 then "nd"
    else if units == 3 && tens != 13 then "rd"
    else "th"

def format (name: []u8) (number: i32): []u8 =
  name ++ ", you are the " ++ (to_string number) ++ (suffix number) ++ " customer we serve today. Thank you!"
