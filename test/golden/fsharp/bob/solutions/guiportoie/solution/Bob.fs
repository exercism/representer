module Bob

let response (input: string): string = 
    let isQuestion (input: string) = input.EndsWith("?")
    let isYelling (input: string) = input.ToUpper() = input && input.ToLower() <> input
    match input.Trim() with
    | input when isQuestion(input) && isYelling(input) -> "Calm down, I know what I'm doing!"
    | input when isQuestion(input) -> "Sure."
    | input when isYelling(input) -> "Whoa, chill out!"
    | input when input = "" -> "Fine. Be that way!"
    | _ -> "Whatever."