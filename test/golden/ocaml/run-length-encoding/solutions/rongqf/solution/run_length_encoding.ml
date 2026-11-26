open Base

let mkstr n x = 
    match n with
    |0 -> ""
    |1 -> x
    |_ -> (Int.to_string n)^x

let encode s =
    let rec en_fun ls x n = 
        match ls with
        |[] -> mkstr n x
        |h::t ->
            if String.(h = x) || Int.(n = 0) then en_fun t h (n+1)
            else (mkstr n x)^(en_fun t h 1)
    in 
    s
    |> String.to_list
    |> List.map ~f:(fun x-> String.of_char x)
    |> (fun x-> en_fun x "" 0)


let decode s =
    let rec de_fen s n =
        if String.(s = "") then ""
        else 
            if Char.is_digit s.[0] then de_fen (String.drop_prefix s 1) (n^(String.of_char s.[0]))
            else 
                if String.(n = "") then (String.of_char s.[0])^(de_fen (String.drop_prefix s 1) "")
                else (String.make (Int.of_string n) s.[0])^(de_fen (String.drop_prefix s 1) "")
    in
    de_fen s ""
    
    