module Pangram

let isPangram (input: string): bool = 
    // get ascii codes for lowercase a - z only
    let ascii_alphabet = seq {97..122}
                         |> Set

    //convert entire input string to ascii codes
    let ascii_input = input.ToLower()
                      |> Seq.map(fun (c: char) -> System.Convert.ToInt32 c) 
                      |> Set

    //checking whether the alphabet is a subset of the input 
    //handles the possibility of non-alphabetic characters being in the input
    ascii_alphabet.IsSubsetOf ascii_input