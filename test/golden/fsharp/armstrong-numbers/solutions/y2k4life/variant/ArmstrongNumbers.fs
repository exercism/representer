module ArmstrongNumbers

let totoalDigits number =
    let lengthOfDigits = Seq.length (sprintf "%i" number)
    Seq.sumBy (fun c -> pown (int c + 48) lengthOfDigits) (sprintf "%i" number)

let isArmstrongNumber (number: int): bool = 
    totoalDigits number = number
