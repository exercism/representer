module ArmstrongNumbers

let isArmstrongNumber (number: int): bool =
    let length = number.ToString().Length

    number.ToString()
    |> Seq.map (string >> int)
    |> Seq.sumBy (fun x -> pown x length)
    |> (=) number

