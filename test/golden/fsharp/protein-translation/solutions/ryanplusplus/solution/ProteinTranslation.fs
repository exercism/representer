module ProteinTranslation

open System

let codonToProtein codon = 
  match codon with 
    | "AUG" -> ("Methionine", false)
    | "UUU" | "UUC" -> ("Phenylalanine", false)
    | "UUA" | "UUG" -> ("Leucine", false)
    | "UCU" | "UCC" | "UCA" | "UCG" -> ("Serine", false)
    | "UAU" | "UAC" -> ("Tyrosine", false)
    | "UGU" | "UGC" -> ("Cysteine", false)
    | "UGG" -> ("Tryptophan", false)
    | _ -> ("", true)

let proteins rna =
  rna
    |> Seq.chunkBySize 3
    |> Seq.map (Seq.toArray >> String >> codonToProtein)
    |> Seq.toList
    |> List.takeWhile (fun (_, stop) -> not stop)
    |> List.map (fun (protein, _) -> protein)
