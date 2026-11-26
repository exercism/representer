module ArmstrongNumbers


let isArmstrongNumber (number: int): bool = 
    let digits = number.ToString()
    let digitsLength = digits.Length

    digits
    |> Seq.map (string >> int) 
    |> Seq.sumBy (fun x -> pown x digitsLength)
    |> (=) number