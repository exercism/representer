module RnaTranscription

let toRna (dna: string): string =
    let transcript =
        function
        | 'G' -> 'C'
        | 'C' -> 'G'
        | 'T' -> 'A'
        | 'A' -> 'U'
        | x -> x
    dna |> String.map transcript
