module TwoFer

let twoFer (input: string option): string =
    match input with
    | Some s -> sprintf "One for %s, one for me." s
    | None -> "One for you, one for me."
