module AffineCipher

open System

let m = 26
let start = (int) 'a'

let isCoprime a m =
    let rec gcd x y =
        let m = x % y
        if m = 0 then
            y
        else
            gcd y m
    gcd a m = 1
    
let rec egcd a b =
    if b = 0 then 
        (a, 1, 0)
    else
        let (_, y, z) = egcd b (a % b)
        (0, z , y - a / b * z )
        
let decode a b cipheredText =
    if isCoprime a m = false then
        raise (ArgumentException("a and m need to be coprime"))
        
    let (_, mmi, _) = egcd a m
    let mmi = if mmi < 0 then mmi + m else mmi
    
    let decChar c =
        if Char.IsNumber c then
            c
        else 
            let res = (mmi * ((int c - start) - b)) % m
            if res < 0 then res + m else res
            |> (+) start
            |> char
   
    cipheredText
    |> Seq.filter Char.IsLetterOrDigit
    |> Seq.map decChar
    |> Array.ofSeq
    |> String
    

let encode a b (plainText: string) =
    if isCoprime a m = false then
        raise (ArgumentException("a and m need to be coprime"))
      
    let encChar c =
         if Char.IsLetter c then 
            ((int (Char.ToLower c) - start) * a + b) % m + start
            |> char
         else
            c
            
    plainText
    |> Seq.filter Char.IsLetterOrDigit
    |> Seq.map encChar
    |> Seq.chunkBySize 5
    |> Array.ofSeq
    |> Array.map String
    |> String.concat " "
