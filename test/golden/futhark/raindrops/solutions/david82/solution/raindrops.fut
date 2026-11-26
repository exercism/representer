-- Convert an i32 to its ASCII decimal representation (as []u8).
let i32_to_string (n: i32): []u8 =
  if n == 0 then
    "0"
  else
    let neg = n < 0
    let m   = if neg then -n else n
    let (digits, _) =
      -- Build digits from least significant to most significant by
      -- repeatedly taking modulo 10, and prepend to keep correct order.
      loop (acc: []u8, x: i32) = ([], m) while x > 0 do
        let d: i32 = x % 10
        let b: u8  = 48 + u8.i32 d     -- 48 = ASCII '0'
        in ([b] ++ acc, x / 10)
    in if neg then "-" ++ digits else digits

-- Return the raindrop sounds for the given number.
let convert (number: i32): []u8 =
  let p3 = number % 3 == 0
  let p5 = number % 5 == 0
  let p7 = number % 7 == 0

  let sound =
    (if p3 then "Pling" else "") ++
    (if p5 then "Plang" else "") ++
    (if p7 then "Plong" else "")

  in if p3 || p5 || p7 then sound else i32_to_string number
  