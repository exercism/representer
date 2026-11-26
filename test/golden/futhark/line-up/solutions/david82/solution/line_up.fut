-- Convert integer to string representation
def int_to_string (n: i32): []u8 =
  if n == 0 then [48] -- "0"
  else
    let (digits, _) = loop (acc, num) = ([], n) while num > 0 do
      let digit = num % 10
      let char = u8.i32 (digit + 48) -- convert to ASCII
      in ([char] ++ acc, num / 10)
    in digits

-- Get ordinal suffix based on number rules
def get_ordinal_suffix (number: i32): []u8 =
  let last_two_digits = number % 100
  let last_digit = number % 10
  in if last_two_digits >= 11 && last_two_digits <= 13 then
       [116, 104] -- "th"
     else if last_digit == 1 then
       [115, 116] -- "st"
     else if last_digit == 2 then
       [110, 100] -- "nd"
     else if last_digit == 3 then
       [114, 100] -- "rd"
     else
       [116, 104] -- "th"

-- Format the customer message
def format (name: []u8) (number: i32): []u8 =
  let number_str = int_to_string number
  let ordinal_suffix = get_ordinal_suffix number
  let message_start = [44, 32, 121, 111, 117, 32, 97, 114, 101, 32, 116, 104, 101, 32] -- ", you are the "
  let message_end = [32, 99, 117, 115, 116, 111, 109, 101, 114, 32, 119, 101, 32, 115, 101, 114, 118, 101, 32, 116, 111, 100, 97, 121, 46, 32, 84, 104, 97, 110, 107, 32, 121, 111, 117, 33] -- " customer we serve today. Thank you!"
  in name ++ message_start ++ number_str ++ ordinal_suffix ++ message_end
         