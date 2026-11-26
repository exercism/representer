fun name (input: string option) =
    case input of
        NONE => "One for you, one for me."
      | SOME x => "One for " ^ x ^ ", one for me."
