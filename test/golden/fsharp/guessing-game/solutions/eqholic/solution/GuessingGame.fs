module GuessingGame

let reply (guess: int): string = 
    match guess with
    | 42 -> "Correct"
    | g when g < 41 -> "Too low" 
    | g when g > 43 -> "Too high"
    | _ -> "So close"
