open Base
open Int64

let rec spellout = function
  | 0L -> "zero"
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
  | 20L -> "twenty"
  | 30L -> "thirty"
  | 40L -> "forty"
  | 50L -> "fifty"
  | 60L -> "sixty"
  | 70L -> "seventy"
  | 80L -> "eighty"
  | 90L -> "ninety"
  | n when n < 100L
    -> spellout ((n / 10L) * 10L)
       ^ "-"
       ^ spellout (rem n 10L)
  | n when (rem n 100L) = 0L
    -> spellout (n / 100L) ^ " hundred"
  | n (* when n < 1000L *)
    -> spellout (n / 100L)
       ^ " hundred "
       ^ spellout (rem n 100L)

let rec calc_scales = function
  | n when n < 1000L -> [n]
  | n -> (rem n 1000L) :: calc_scales (n / 1000L)

let rec zip_until xs ys = match xs, ys with
  | [], _ -> []
  | _, [] -> []
  | (x::xs_tl), (y::ys_tl) -> (x, y) :: zip_until xs_tl ys_tl

let filter_empty xs =
  if Int.(List.length xs > 1)
  then List.filter xs ~f:(fun (x, _) -> x <> 0L)
  else xs

let fold_scales n =
  let scales = [""; " thousand"; " million"; " billion"] in
  calc_scales n
  |> (fun x -> zip_until x scales)
  |> filter_empty
  |> List.rev_map ~f:(fun (x, scale) -> spellout x ^ scale)
  |> String.concat ~sep:" "

let in_english = function
  | n when n < 0L
        || n > 999_999_999_999L -> Error "input out of range"
  | n -> Ok (fold_scales n)
