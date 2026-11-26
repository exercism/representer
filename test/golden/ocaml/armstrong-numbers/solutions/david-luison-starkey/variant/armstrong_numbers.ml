open Base

(* 
    1. Loop over every digit in the number  
    2. exponentiate the digit to the power of the length of the number n (i.e. how many digits in the number) 
    3. Sum the result of all the squares together
    4. Check if result equals number
*)

let validate n =
  let digits_list =
    Int.to_string (abs n) |> String.to_sequence |> Sequence.to_list
  in
  let exp = List.length digits_list in
  let sum =
    List.map digits_list ~f:(fun c -> Char.to_int c + Char.to_int '0')
    |> List.map ~f:(fun i -> i ** exp)
    |> List.sum (module Int) ~f:Fn.id
  in
  sum = n
