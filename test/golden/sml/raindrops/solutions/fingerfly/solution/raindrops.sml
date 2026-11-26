fun convert n =
  let val s3 = if n mod 3 = 0 then "Pling" else ""
      val s5 = if n mod 5 = 0 then "Plang" else ""
      val s7 = if n mod 7 = 0 then "Plong" else ""
      val s_all = s3 ^ s5 ^ s7
      fun is_empty "" = true
      |   is_empty _ = false
  in if is_empty s_all then Int.toString(n) else s_all
  end
