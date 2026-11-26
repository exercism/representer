open Base

let factors_of n =
  let open Int64 in
  let rec aux n cand acc =
    if cand * cand <= n
    then begin
      if n % cand = 0L
      then aux (n / cand) cand (cand :: acc)
      else aux n (succ cand) acc
    end
    else (if n <> 1L then n :: acc else acc)
  in
  if n < 2L then [] else aux n 2L [] |> List.rev
