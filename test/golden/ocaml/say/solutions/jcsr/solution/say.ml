open Base.Int64

let digits = function
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
  | _ -> ""

let to_tens n =
  let last d = if d = 0L then "" else "-" ^ digits d in
  match n / 10L, n % 10L with
  | 0L, n -> digits n
  | 1L, 0L -> "ten"
  | 1L, 1L -> "eleven"
  | 1L, 2L -> "twelve"
  | 1L, 3L -> "thirteen"
  | 1L, 4L -> "fourteen"
  | 1L, 5L -> "fifteen"
  | 1L, (6L | 7L as d) -> digits d ^ "teen"
  | 1L, 8L -> "eighteen"
  | 1L, 9L -> "nineteen"
  | 2L, d -> "twenty" ^ last d
  | 3L, d -> "thirty" ^ last d
  | 4L, d -> "forty" ^ last d
  | 5L, d -> "fifty" ^ last d
  | (6L | 7L as t), d -> digits t ^ "ty" ^ last d
  | 8L, d -> "eighty" ^ last d
  | 9L, d -> "ninety" ^ last d
  | _ -> ""

let thousands = [|""; " thousand"; " million"; " billion"|]

let to_hundreds n =
  let last t = if t = 0L then "" else " " ^ to_tens t in
  match n/100L, n%100L with
  | 0L, t -> to_tens t
  | h, t -> digits h ^ " hundred" ^ last t

let rec thousand_chunks acc n =
  if n/1_000L = 0L then n%1_000L::acc
  else thousand_chunks (n%1_000L::acc) (n/1_000L)

let to_thousands n =
  thousand_chunks [] n
  |> List.rev
  |> List.mapi (fun i e -> e, thousands.(i))
  |> List.filter (fun (e, _) -> e <> 0L)
  |> (function [] -> [0L, ""] | l -> l)
  |> List.map (fun (e, s) -> to_hundreds e ^ s)
  |> List.rev
  |> String.concat " "

let in_english n =
  if n < 0L || n > 999_999_999_999L then Error "input out of range"
  else Ok (to_thousands n)
