module ReverseString

rev_append : List Char -> List Char -> List Char
rev_append acc [] = acc
rev_append acc (x :: xs) = rev_append (x :: acc) xs

export
rev : String -> String
rev = pack . (rev_append []) . unpack
