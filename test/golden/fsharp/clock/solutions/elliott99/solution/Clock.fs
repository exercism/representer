module Clock

let modByDay x = x % 1440


let create (hours: int) (minutes: int) = 
    let answer = ((60 * hours) + minutes) |> modByDay
    if answer < 0 then answer + 1440 else answer

let add minutes clock = create 0 (clock + minutes)

let subtract minutes clock = create 0 (clock - minutes)

let display clock = 
    sprintf "%02i:%02i" (clock / 60) (clock % 60)