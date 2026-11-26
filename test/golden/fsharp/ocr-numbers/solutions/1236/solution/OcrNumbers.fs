module OcrNumbers

let _convert input = 
    match input with
        | [" _ "; "| |"; "|_|"; "   "] -> "0"
        | [ "   ";"  |";"  |"; "   " ] -> "1"
        | [ " _ ";" _|";"|_ "; "   " ] -> "2"
        | [ " _ ";" _|";" _|"; "   " ] -> "3"
        | [ "   "; "|_|";"  |";"   " ] -> "4"
        | [ " _ ";"|_ ";" _|";"   "  ] -> "5"
        | [ " _ ";"|_ ";"|_|";"   " ] -> "6"
        | [ " _ ";"  |";"  |";"   " ] -> "7"
        | [ " _ ";"|_|";"|_|";"   " ] -> "8"
        | [ " _ ";"|_|";" _|";"   " ] -> "9"
        | _ -> "?"

let destructure (s:string) = 
    [0..s.Length / 3 - 1] 
    |> List.map (fun i -> i*3) 
    |> List.map (fun i -> s[i..i+2]) 

let _convertS input = 
        let d = input |> List.map destructure
        List.zip3 d.[0] d.[1] d.[2]
            |> List.map (fun (x, y, z) -> [x; y; z; "   "])
            |> List.map _convert
            |> String.concat ""
    

let convert (input : string list) = 
    if input.Length % 4 <> 0 then None
    elif input |> List.exists (fun x -> x.Length % 3 <> 0) then None
    elif input.Length <> 4 then 
        input 
            |> List.splitInto (input.Length / 4)
            |> List.map _convertS 
            |> String.concat ","
            |> Some
    else 
        Some(_convertS input)