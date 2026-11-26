module Pangram

let isPangram (input: string): bool = 
    (* Solution 1
    let input = input.ToLower()
    let charPresent : int array = Array.zeroCreate 26
    let markchar inchar = 
        if (inchar >= 'a') && (inchar <= 'z') then charPresent.[(int inchar - int 'a')] <- 1 else ()
    String.iter markchar input
    let numchars = Seq.sum charPresent
    // printf "numchars = %d" numchars
    numchars = 26
    *)
    set ['a'..'z'] - set(input.ToLower()) |> Set.isEmpty