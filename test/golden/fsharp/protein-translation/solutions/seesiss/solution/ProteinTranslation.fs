module ProteinTranslation

let codonToAminoAcid = function
    | "AUG" -> "Methionine"
    | "UGG" -> "Tryptophan"
    | "UUC" | "UUU" -> "Phenylalanine"
    | "UUA" | "UUG" -> "Leucine"
    | "UAU" | "UAC" -> "Tyrosine"
    | "UGU" | "UGC" -> "Cysteine"
    | "UCU" | "UCC" | "UCA" | "UCG" -> "Serine"
    | "UAA" | "UAG" | "UGA" -> "STOP"
    | _ -> failwith "Invalid RNA"

let convertToOption (rna: string) =
    if rna.Length < 3 then None
    else
        let aminoAcid = codonToAminoAcid rna[0..2]
        if aminoAcid = "STOP" then None
        else Some(aminoAcid, rna[3..])

let proteins rna =
    List.unfold convertToOption rna