module Sublist

type SublistType = Equal | Sublist | Superlist | Unequal

let sublist (xs: List<'a>) (ys: List<'a>) = 
  
  let rec sublist (l: List<'a>) (s: List<'a>) =
    match l, s with
    | a, b when a.Length < b.Length -> false
    | a, b when a |> List.take b.Length = b -> true
    | _ -> sublist l.Tail s

  match xs, ys with
    | a, b when a = b -> Equal
    | a, b when a.Length > b.Length && sublist a b -> Superlist 
    | a, b when a.Length < b.Length && sublist b a -> Sublist
    | _ -> Unequal