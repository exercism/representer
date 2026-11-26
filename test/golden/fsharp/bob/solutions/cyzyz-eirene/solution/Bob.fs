module Bob

let response (input: string): string =
    let isQuestion (input: string): bool = input.EndsWith('?')
    let isYelling (input: string): bool = (input = input.ToUpper()) && not (input = input.ToLower())
    match input.Trim() with
        | "" -> "Fine. Be that way!"
        | input when isQuestion(input) && isYelling(input) -> "Calm down, I know what I'm doing!"
        | input when isQuestion(input) -> "Sure."
        | input when isYelling(input) -> "Whoa, chill out!"
        | input -> "Whatever."