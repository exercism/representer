open Base
open Int64

let lt20 = function
  | 0L -> ""
  | 1L -> "one"
  | 2L -> "two"
  | 3L -> "three"
  | 4L -> "four"
  | 5L -> "five"
  | 6L -> "six"
  | 7L -> "seven"
  | 8L -> "eight"
  | 9L -> "nine"
  | 10L -> "ten"
  | 11L -> "eleven"
  | 12L -> "twelve"
  | 13L -> "thirteen"
  | 14L -> "fourteen"
  | 15L -> "fifteen"
  | 16L -> "sixteen"
  | 17L -> "seventeen"
  | 18L -> "eighteen"
  | 19L -> "nineteen"
  | _ -> raise (Invalid_argument "Argument must be less than 20")

let tenty x y =
  if y = 0L then x else x ^ "-" ^ (lt20 y)

let lt100 x =
  let tens = x / 10L in
  let ones = x % 10L in
  match tens with
  | 0L | 1L -> lt20 x
  | 2L -> tenty "twenty" ones
  | 3L -> tenty "thirty" ones
  | 4L -> tenty "forty" ones
  | 5L -> tenty "fifty" ones
  | 6L -> tenty "sixty" ones
  | 7L -> tenty "seventy" ones
  | 8L -> tenty "eighty" ones
  | 9L -> tenty "ninety" ones
  | _ -> raise (Invalid_argument "Argument must be less than 100")

let lt1000 x = 
  match (x / 100L, x % 100L) with
  | (0L, t) -> lt100 t
  | (h, 0L) -> (lt20 h) ^ " hundred"
  | (h, t) -> (lt20 h) ^ " hundred " ^ (lt100 t)

let rec split_1000s x =
  if x < 1000L then [x]
  else [x % 1000L] @ split_1000s (x / 1000L)

let scale = function
  | 0 -> ""
  | 1 -> "thousand"
  | 2 -> "million"
  | 3 -> "billion"
  | 4 -> "trillion"
  | _ -> raise (Invalid_argument "Argument must be less than 5")

let in_english x =
  if (x < 0L) || (x >= 999_999_999_999L) then
    Error "input out of range"
  else if x = 0L then Ok "zero"
  else
    Ok (
      split_1000s x
      |> List.mapi ~f:(fun i y -> 
          if y = 0L then ""
          else match i with
          | 0 -> (lt1000 y)
          | _ -> (lt1000 y) ^ " " ^ (scale i))
      |> List.rev
      |> String.concat ~sep:" "
      |> String.strip
    )
