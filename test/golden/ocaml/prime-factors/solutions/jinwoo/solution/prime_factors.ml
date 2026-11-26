open Base

let factors_of num =
  let rec aux n divisor acc = Int64.(
      match n with
      | 1L -> List.rev acc
      | n when n % divisor = 0L -> aux (n / divisor) divisor (divisor :: acc)
      | n ->
        let inc = if divisor > 2L then 2L else 1L in
        aux n (divisor + inc) acc)
  in
  aux num 2L []