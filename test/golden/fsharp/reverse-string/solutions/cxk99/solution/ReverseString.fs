module ReverseString

let reverse (input: string): string =  
    //input |> Seq.toList |> List.rev |> List.map string |> List.fold (+) ""
    input |> Seq.rev |> System.String.Concat