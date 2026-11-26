def remove_international_code (digits: []u8) : []u8 =
  if digits[0] == '1'
  then digits[1:]
  else digits

def clean (phrase: []u8) : []u8 =
  let digits = phrase |> filter (\c -> c >= '0' && c <= '9') |> remove_international_code
  in assert (length digits == 10
             || (any (\d -> digits[0] == d) "23456789")
             && (any (\d -> digits[3] == d) "23456789"))
     digits
