fun isValid (isbn: string) =
  let fun sum     []  acc n = if n <> 0 then 0 else acc
     | sum (#"X"::[]) acc n = sum [] (acc+10) (n-1)
     | sum (#"-"::xs) acc n = sum xs acc n
     | sum ( x :: xs) acc n = if Char.isDigit x then sum xs (acc + (ord(x)-49) * n) (n-1) else 0
  in
    case sum (explode isbn) 0 10
      of 0 => false
       | n => n mod 11 = 0
  end