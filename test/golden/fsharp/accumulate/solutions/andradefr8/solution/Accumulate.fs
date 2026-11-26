module Accumulate

let accumulate (func: 'a -> 'b) (input: 'a list): 'b list = 
    let rec calculateFunc func acc input  = 
        match input with
        | [] -> acc
        | hd::tls -> calculateFunc func (func hd :: acc) tls
    calculateFunc func [] input |> List.rev