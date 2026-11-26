module TwoFer

let twoFer (input: string option): string = "One for " + (match input with | Some(input) -> input | None -> "you") + ", one for me."