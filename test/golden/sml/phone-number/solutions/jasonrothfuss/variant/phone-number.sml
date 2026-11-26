open Char

infix |>
fun x |> f = f x

fun validate (#"1"::x0::x1::x2::x3::x4::x5::x6::x7::x8::x9::[]) =
  if x0 > #"1" andalso x0 <= #"9"
  then if x3 > #"1" andalso x3 <= #"9"
       then SOME (implode [x0,x1,x2,x3,x4,x5,x6,x7,x8,x9])
       else NONE
  else NONE

  | validate (x0::x1::x2::x3::x4::x5::x6::x7::x8::x9::[]) =
  if x0 > #"1" andalso x0 <= #"9"
  then if x3 > #"1" andalso x3 <= #"9"
       then SOME (implode [x0,x1,x2,x3,x4,x5,x6,x7,x8,x9])
       else NONE
  else NONE

  | validate _ = NONE

fun clean (text: string): string option =
  explode text |> List.map Char.isDigit |> validate
