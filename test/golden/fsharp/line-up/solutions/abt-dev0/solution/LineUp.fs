module LineUp

let format (name: string) (number: int): string =
    let suffix =
        match number % 100 with
        | 11 | 12 | 13 -> "th"
        | _ ->
            match number % 10 with
            | 1 -> "st"
            | 2 -> "nd"
            | 3 -> "rd"
            | _ -> "th"
    $"{name}, you are the {number}{suffix} customer we serve today. Thank you!"