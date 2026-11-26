open Base

type base = int

let digits_ok ~base digits =
  if base > 1 then
    List.for_all ~f:(fun x -> x >= 0 && x < base) digits
  else
    false

let digitize ~base n =
  let rec helper acc x = match x with
    | 0 -> if 0 = List.length acc then [0] else acc
    | _ -> (helper [@tailcall]) ((Int.rem x base)::acc) (x / base)
  in (helper [@tailcall]) [] n

let convert_bases ~from ~digits ~target =
  match (digits_ok ~base:from digits) with
  | false -> None
  | true when target < 2 -> None
  | true  ->
    List.fold_map ~init:((List.length digits)-1) ~f:(fun b a  -> (b-1, a * from ** b)) digits
    |> snd
    |> List.fold ~init:0 ~f:(+)
    |> digitize ~base:target
    |> (fun a -> Some a)
