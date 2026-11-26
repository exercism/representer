module LargestSeriesProduct

open System.Text.RegularExpressions

let filterInvalidSubstrings length (s:string [])  = 
    s 
    |> Array.filter (fun s -> s.Length >= length)


let window length (s:string) = s |> Seq.windowed length |> Seq.toArray 

let product (s:char [] []) =
    s
    |> Array.map (fun s -> s |> Seq.fold (fun acc c -> (c |> System.Char.GetNumericValue |> int) * acc) 1)

let validLength l = l >= 0
let validCharacters s = 
    s 
    |> Seq.forall(fun c -> 
        let zeroCharCode = '0' |> int
        let nineCharCode = '9' |> int
        let cCharCode = c |> int
        cCharCode >= zeroCharCode && cCharCode <= nineCharCode)

let largestProduct (input:string) seriesLength : int option = 
    let vL = validLength seriesLength
    let vC = validCharacters input
    //let splitInput = Regex.Split(input, "(0)")
    match vL && vC with
    | false -> None
    | _ -> 
        match seriesLength with
        | 0 -> Some(1)
        | _ -> 
            let products = 
                input
                |> window seriesLength
                |> product

            match products with
            | [||] -> None
            | _ -> Some(products |> Array.max)
