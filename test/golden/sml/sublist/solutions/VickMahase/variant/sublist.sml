datatype Sublist = Equal | Sublist | Superlist | Unequal

(* Check if prefix p matches the front of l *)
fun startsWith (p, l) =
  case (p, l) of
      ([], _) => true
    | (_, []) => false
    | (x::xs, y::ys) => x = y andalso startsWith(xs, ys)

(* Is 'small' a contiguous sublist of 'big'? *)
fun isSublist (small, big) =
  let
    val lenSmall = length small
    val lenBig   = length big
    fun loop l =
      if length l < lenSmall then false
      else if startsWith(small, l) then true
      else loop (tl l)
  in
    if lenSmall = 1 then true
    else loop big
  end

fun sublist (a, b) =
  if a = b then Equal
  else if isSublist(a, b) then Sublist
  else if isSublist(b, a) then Superlist
  else Unequal