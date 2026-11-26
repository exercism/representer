module ArmstrongNumbers

let isArmstrongNumber (number: int): bool =
    let digits = number.ToString()
    let length = digits.Length

    digits
    |> Seq.map (string >> int)
    |> Seq.sumBy (fun d -> pown d length)
    |> (=) number
