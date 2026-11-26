open Base
open Int64
open Result

let basic = function
  | 1L -> Ok "one"
  | 2L -> Ok "two"
  | 3L -> Ok "three"
  | 4L -> Ok "four"
  | 5L -> Ok "five"
  | 6L -> Ok "six"
  | 7L -> Ok "seven"
  | 8L -> Ok "eight"
  | 9L -> Ok "nine"
  | 10L -> Ok "ten"
  | 11L -> Ok "eleven"
  | 12L -> Ok "twelve"
  | 13L -> Ok "thirteen"
  | 14L -> Ok "fourteen"
  | 15L -> Ok "fifteen"
  | 16L -> Ok "sixteen"
  | 17L -> Ok "seventeen"
  | 18L -> Ok "eighteen"
  | 19L -> Ok "nineteen"
  | _ -> Error "input out of range"

let tens = function
  | 2L -> Ok "twenty"
  | 3L -> Ok "thirty"
  | 4L -> Ok "forty"
  | 5L -> Ok "fifty"
  | 6L -> Ok "sixty"
  | 7L -> Ok "seventy"
  | 8L -> Ok "eighty"
  | 9L -> Ok "ninety"
  | _ -> Error "input out of range"

let transform_result_list ?(sep = " ") l =
  l
  |> List.filter ~f:(function
       | Ok v -> not @@ String.is_empty v
       | Error _ -> true)
  |> Result.all
  |> Result.map ~f:(String.concat ~sep)

let rec non_zero = function
  | 0L -> Ok ""
  | n when n < 20L -> basic n
  | n when n < 100L ->
      [ tens (n / 10L); non_zero @@ Int64.rem n 10L ]
      |> transform_result_list ~sep:"-"
  | n when n < 1_000L -> thousands_and_more n 100L "hundred"
  | n when n < 1_000_000L -> thousands_and_more n 1_000L "thousand"
  | n when n < 1_000_000_000L -> thousands_and_more n 1_000_000L "million"
  | n when n < 1_000_000_000_000L ->
      thousands_and_more n 1_000_000_000L "billion"
  | _ -> Error "input out of range"

and thousands_and_more n denom word =
  [ non_zero (n / denom); Ok word; non_zero @@ Int64.rem n denom ]
  |> transform_result_list

let in_english = function 0L -> Result.Ok "zero" | n -> non_zero n
