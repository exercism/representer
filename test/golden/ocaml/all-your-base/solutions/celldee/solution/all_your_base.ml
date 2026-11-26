open Base

type base = int

let valid_digits base digits =
    List.for_all ~f:(fun x -> x < base && x >= 0) digits

let to_dec base digits =
    if List.is_empty digits then 0
    else
        List.rev digits |>
        List.mapi ~f:(fun i x -> x * base**i) |>
        List.fold ~f:( + ) ~init:0
   
let digits_from_dec base dec_val =
    let rec aux b d acc =
        let quotient = d /% b in
        let remainder = d % b in
        if quotient > 0 then aux b quotient (remainder :: acc)
        else remainder :: acc
    in aux base dec_val []

let convert_bases ~from ~digits ~target =
    if from < 2 || target < 2 || not (valid_digits from digits) then None
    else
        let dec_val = to_dec from digits in
        let ret_digits = digits_from_dec target dec_val in
        Some ret_digits