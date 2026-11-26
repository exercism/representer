module LineUp

toOrdinal : Int -> String
toOrdinal n =
  case lastDigit of
    1 => if lastTwoDigits == 11 then "\{show n}th" else "\{show n}st"
    2 => if lastTwoDigits == 12 then "\{show n}th" else "\{show n}nd"
    3 => if lastTwoDigits == 13 then "\{show n}th" else "\{show n}rd"
    _ => "\{show n}th"
  where
    lastDigit : Int
    lastDigit = n `mod` 10

    lastTwoDigits : Int
    lastTwoDigits = n `mod` 100 

export
format : String -> Int -> String
format name number =
  "\{name}, you are the \{toOrdinal number} customer we serve today. Thank you!"
