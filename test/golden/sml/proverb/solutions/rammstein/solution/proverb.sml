fun recite (inputs: string list) =
  let fun line (p, [], s) = s
       | line (p, [x], s) = line (x, [], (s@["For want of a "^ p ^" the "^ x ^" was lost.\n"]))
       | line (p, (x::y::ys), s) = line (x, (y::ys), (s@["For want of a "^ p ^" the "^ x ^" was lost.\n"]))
  in
    case inputs
      of [] => ""
      | x::xs => foldr (fn (x,a) => x ^ a) "" (line (x, xs, [])) ^ "And all for the want of a " ^ x ^ "."
  end