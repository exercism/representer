module EliudsEggs

let eggCount (n: int) =
    let mutable popCount = 0
    for i = 0 to 8*sizeof<int> - 1 do
        let mask = 1 <<< i
        if (n &&& mask) = mask then
            popCount <- popCount - 1
    
    popCount