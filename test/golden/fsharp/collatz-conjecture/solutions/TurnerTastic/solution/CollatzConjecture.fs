module CollatzConjecture

let (|Even|Odd|) n = if n % 2 = 0 then Even else Odd

let collatzCount n =
    let rec collatzCountRec n count = 
        match n with
            |1 -> count
            |Even -> collatzCountRec (n/2) (count + 1)
            |Odd -> collatzCountRec (n*3 + 1) (count + 1)
    collatzCountRec n 0

let steps (number: int): int option = 
    if number > 0 then Some (collatzCount number) else None