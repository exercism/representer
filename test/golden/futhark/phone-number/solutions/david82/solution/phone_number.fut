def clean (phrase: []u8): []u8 = 
  -- Extract only digits from the input string
  let digits = filter (\c -> c >= u8.i64('0') && c <= u8.i64('9')) phrase
  let num_digits = length digits
  
  -- Get the final 10-digit number after handling country code
  let final_digits = 
    if num_digits == 10 then digits
    else if num_digits == 11 && digits[0] == u8.i64('1') then digits[1:]
    else assert false [] -- Invalid length or invalid country code
  
  -- Validate area code (first digit must be 2-9)
  let area_first = final_digits[0] - u8.i64('0')
  
  -- Validate exchange code (4th digit must be 2-9)
  let exchange_first = final_digits[3] - u8.i64('0')
  
  -- Return the cleaned number if both area code and exchange code are valid
  in assert (area_first >= 2 && area_first <= 9 && 
             exchange_first >= 2 && exchange_first <= 9) final_digits
        