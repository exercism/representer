module RnaTranscription

let toRna (dna: string): string =
    let transcribe = function
        | 'G' -> 'C'
        | 'C' -> 'G'
        | 'T' -> 'A'
        | 'A' -> 'U'
        | unknown -> unknown //do nothing
    dna |> String.map transcribe