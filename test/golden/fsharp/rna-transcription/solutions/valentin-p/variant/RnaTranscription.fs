module RnaTranscription

let rnaMapping = ['G','D'; 'C','G'; 'T','A'; 'A','U'] |> Map.ofSeq
let rnaTranscriptor nucleotide = 
    match rnaMapping.TryFind nucleotide with
    | Some transcripted -> transcripted
    | None -> invalidArg "nucleotide" (sprintf "Expected G,C,T or U, got %c" nucleotide)

let toRna (dna: string): string = String.map rnaTranscriptor dna