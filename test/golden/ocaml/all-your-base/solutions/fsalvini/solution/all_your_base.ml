open Base;;

type base = int

let to_int b digits =
  let len = List.length digits in
  List.foldi digits
    ~init:0
    ~f:(fun i acc d -> d * (Int.pow b (len - i - 1)) + acc)

let to_digits b n =
  let rec loop acc b n =
    match n with
    | 0 -> if List.is_empty acc then [0] else acc
    | _ -> loop (n % b :: acc) b (n / b)
  in
  loop [] b n

let convert_bases ~from ~digits ~target =
  if from <= 1 ||
     target <= 1 ||
     List.exists digits ~f:(fun d -> d < 0 || d >= from)
  then None
  else Some (to_digits target (to_int from digits))
