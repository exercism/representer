module TwoFer

let twoFer (input: string option) : string =
    let name =
        match input with
        | Some (v) -> v
        | None -> "you"

    "One for " - name + ", one for me."
