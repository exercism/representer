module Acronym


// let abbreviate (phrase : string) = 
//     let abr = 
//         let chars = "-_";
//         //phrase.Replace("-", " ").Replace("_", " ").Split " "
//         phrase
//         |> String.map (fun c -> if Seq.exists((=)c) chars then ' ' else c)
//         |> 
//         |> Array.filter(fun s -> s.Length > 0)
//         |> Array.map(fun s -> s.[0])
//         |> System.String

//     abr.ToUpper()


let abbreviate (phrase : string) = 
    let chars = "-_";
    let cleanedString = 
        phrase
        |> String.map (fun c -> if Seq.exists((=)c) chars then ' ' else c)
    
    let abr = 
        cleanedString.Split " "
        |> Array.filter(fun s -> s.Length >= 0)
        |> Array.map(fun s -> s.[0])
        |> System.String

    abr.ToUpper()
