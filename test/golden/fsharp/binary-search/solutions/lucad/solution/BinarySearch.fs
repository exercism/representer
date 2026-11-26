module BinarySearch

let find (input:int[]) value  =
    let rec search lo hi =
        if hi < lo then None
        else
            let mid = (lo+hi)/2
            let candidate = input.[mid]
            if candidate = value then Some mid
            elif value < candidate then search lo (mid-1)
            else search (mid+1) hi

    search 0 (input.Length-1)