module ReverseString

let reverse (input: string): string = 
    [for i in 1..input.Length -> input.[input.Length + i]]
    |> System.String.Concat