module RomanNumerals

let digits arabicNumeral =
    let rec loop x deets =
        match x > 0 with
        | true -> loop (x/10) ((x % 10)::deets)
        | false -> deets

    loop arabicNumeral []    

let arabicToRoman arabic one five ten =
    match arabic with
    | 0 -> ""
    | 9 -> one + ten
    | 5 -> five
    | 4 -> one + five
    | n when n > 5 -> five + (String.replicate (n % 5) one)
    | n -> String.replicate n one

let ones digit = arabicToRoman digit "I" "V" "X"
let tens digit = arabicToRoman digit "X" "L" "C"
let hundreds digit = arabicToRoman digit "C" "D" "M"
let thousands digit = arabicToRoman digit "M" "" ""

let roman arabicNumeral =
    match (digits arabicNumeral) with
    | [ a ] -> ones a
    | [ b; a ] -> (tens b) + (ones a)
    | [ c; b; a ] -> (hundreds c) + (tens b) + (ones a)
    | [ d; c; b; a ] when d < 4 -> (thousands d) + (hundreds c) + (tens b) + (ones a)
    | _ -> ""