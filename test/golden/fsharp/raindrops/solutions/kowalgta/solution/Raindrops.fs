module Raindrops

let convert (number: int): string = 
    [
        (3, "Pling")
        (5, "Plang")
        (7, "Plong")
    ]
    |> List.choose(fun (divisor, sound) -> 
        if number % divisor = 0 then Some sound else None)
    |> function
    | [] -> string number
    | xs -> String.concat "" xs