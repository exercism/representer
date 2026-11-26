module Pangram
let isPangram (input: string) : bool =
    let alphabet: char list = [ 'a' .. 'z' ]

    let rec isPangramRec (input: string) (letters: char list) : bool =
        match letters with
        | [] -> true
        | hd :: tl ->
            if input.Contains(hd) then
                isPangramRec input tl
            else
                false

    isPangramRec (input.ToLower()) alphabet