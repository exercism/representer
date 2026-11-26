module ArmstrongNumbers

let isArmstrongNumber (number: int): bool =
    let inString = number.ToString()
    let numberOfDigits = inString.Length
    inString
    |> Seq.map (string >> int) 
    |> Seq.sumBy (fun x -> pown x numberOfDigits)
    |> (=) number
    