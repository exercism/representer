module RomanNumerals

let roman arabicNumeral = 

    let translations = [(1000, "M"); (500, "D");(100, "C");(50, "L");(10,"X");(5, "V");]
                       |> List.map (fun (v, n) -> (String.replicate v "I", n))
    
    let shortenings = [("DCCCC", "CM"); ("CCCC", "CD"); ("LXXXX", "XC"); ("XXXX", "XL"); ("VIIII", "IX"); ("IIII", "IV"); ]
    
    let replace (s:string) ((old:string), new') = s.Replace(old, new')

    let replaceAll map s = List.fold replace s map
   
    String.replicate arabicNumeral "I"
    |> replaceAll translations
    |> replaceAll shortenings