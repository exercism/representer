module Grains

let square (n: int): Result<uint64,string> =
    match n with
    | n when n<=0 || n>64 -> Error "square must be between 1 and 64"
    | _ ->  pown 2UL (n-1) |> Ok 


let total: Result<uint64,string> =
    Ok 18446744073709551615UL