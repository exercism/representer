module RunLengthEncoding

let encode (input: string) =
    if input = "" then ""
    else 
        let rec compress count char (tail: char list) =
            match tail with
            | [] -> $"{if count > 1 then string count else System.String.Empty}{char}"
            | h::t when h = char -> compress (count + 1) char t
            | h::t -> $"{if count > 1 then string count else System.String.Empty}{char}" + compress 1 h t
        let ls = Seq.toList input
        compress 1 (List.head ls) (List.tail ls)



let decode (input: string) =
    let rec decompress count (tail: char list) =
        match tail with
        | [] -> ""
        | h::t when System.Char.IsDigit h -> decompress (count + string h) t
        | h::t -> if count = "" then string h + decompress "" t
                  else System.String(h,int count) + decompress "" t

    let ls = Seq.toList input
    decompress "" ls