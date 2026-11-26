def two_fer (name: []u8): []u8 =
  if null name then "One for you, one for me."
  else
  "One gor " ++ name ++ ", one for me."
