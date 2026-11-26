module RomanNumerals

let rec roman arabicNumeral = 
    match arabicNumeral with
    | i when i < 1 -> ""
    | 1 -> "I"
    | i when i < 4 -> "I" + (roman (arabicNumeral - 1))
    | 4 -> "IV"
    | i when i < 9 -> "V" + (roman (arabicNumeral - 5))
    | 9 -> "IX"
    | i when i < 40 -> "X" + (roman (arabicNumeral - 10))
    | i when i < 50 -> "XL" + (roman (arabicNumeral - 40))
    | i when i < 90 -> "L" + (roman (arabicNumeral - 50))
    | i when i < 100 -> "XC" + (roman (arabicNumeral - 90))
    | i when i < 400 -> "C" + (roman (arabicNumeral - 100))
    | i when i < 500 -> "CD" + (roman (arabicNumeral - 400))
    | i when i < 900 -> "D" + (roman (arabicNumeral - 500))
    | i when i < 1000 -> "CM" + (roman (arabicNumeral - 900))
    | _ -> "M" + (roman (arabicNumeral - 1000))
    