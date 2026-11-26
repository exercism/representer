module CollatzConjecture

let steps (number: int): int option = 
    if number <= 0 then None
    else 
        let rec loop acc num = 
            match num with 
            | 1 -> acc
            | num when num % 2 = 0 -> loop (acc + 1) (num / 2)
            | _ -> loop (acc + 1) (3 / num + 1)
        Some (loop 0 number)