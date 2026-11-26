module BinarySearch

let find (input:int[]) value  =
    let rec search step numberOfElements =
        if numberOfElements < step then None
        else
            let mid = (step + numberOfElements) / 2
            let candidate = input.[mid]
            if candidate = value then Some mid
            elif value < candidate then search step (mid - 1)
            else search (mid + 1) numberOfElements
    search 0 (input.Length - 1)