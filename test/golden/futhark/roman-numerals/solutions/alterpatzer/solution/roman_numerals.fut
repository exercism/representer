def roman (n: i32): []u8 =
  match n
  case 1000 -> "M"
  case 900 -> "CM"
  case 500 -> "D"
  case 400 -> "CD"
  case 100 -> "C"
  case 90 -> "XC"
  case 50 -> "L"
  case 40 -> "XL"
  case 10 -> "X"
  case 9 -> "IX"
  case 5 -> "V"
  case 4 -> "IV"
  case 1 -> "I"
  case _ -> assert false "WTF"

def to_roman (number: i32): []u8 =
  let units = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
  let (r, _, _) =
    loop (r, n, i) =
      ("", number, 0)
      while n != 0 do
        let u = units[i]
        in
          if n >= u
          then (r ++ roman u, n - u, i)
          else (r, n, i + 1)
  in r
