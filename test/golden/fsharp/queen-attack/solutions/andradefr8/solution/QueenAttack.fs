module QueenAttack

let create (position: int * int) = 
    match position with
    | (a, b) when a < 0 || b < 0 -> false
    | (a, b) when a <= 7 && b <=7 -> true
    | _ -> false

let canAttack (queen1: int * int) (queen2: int * int) = 
    match queen1 with
    | (a, _) when a = fst queen2 -> true
    | (_, b) when b = snd queen2 -> true
    | (a, b) when abs(a - fst queen2) = abs(b - snd queen2) -> true
    | _ -> false