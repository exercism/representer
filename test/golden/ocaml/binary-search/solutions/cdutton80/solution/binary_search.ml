let find arr elt =
  let rec aux arr elt lower upper =
    let mid = (lower + upper) / 2 in
    let at_mid = arr.(mid) in
    if at_mid = elt then Ok mid
    else if abs (lower - upper) <= 1 || lower > upper then Error "value not in array"
    else if at_mid < elt then aux arr elt mid upper
    else aux arr elt lower mid
  in
  if arr = [||] then Error "value not in array"
  else aux arr elt 0 (Array.length arr)