module ArmstrongNumbers

let isArmstrongNumber (number: int): bool =
    let d = number.ToString().Length;
    number.ToString() |> Seq.map(string >> int)
            |> Seq.sumBy(fun x -> pown x d ) |> (=) number
    