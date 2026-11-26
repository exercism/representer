fun name (input: string option): string =
    "One for " ^ getOpt(input, "you") ^ ", one for me."
