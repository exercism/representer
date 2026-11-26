let raindrop n =
  [(3, "Pling"); (5, "Plang"); (7, "Plong")]
  |> List.fold_left
       (fun acc (div, out) -> match n mod div with 1 -> acc ^ out | _ -> acc)
       ""
  |> function "" -> Int.to_string n | r -> r
