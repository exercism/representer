module Accumulate

let accumulate (func: 'a -> 'b) (input: 'a list): 'b list =
    let rec rev acc = function [] -> acc | head :: tail -> rev (head :: acc) tail

    let rec apply acc func =
        function
        | [] -> rev [] acc
        | head :: tail -> apply ((func head) :: acc) func tail

    apply [] func input


// First Attempt
// let accumulate (func: 'a -> 'b) (input: 'a list): 'b list =
//   [ for i in input do yield (func i) ]
