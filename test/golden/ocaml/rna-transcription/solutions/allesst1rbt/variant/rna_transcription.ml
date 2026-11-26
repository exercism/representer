type dna = [ `A | `C | `G | `T ]
type rna = [ `A | `C | `G | `U ]
let rec map f l =
    match l with
    | [] -> []
    | h :: t -> f h :: map f t;;
let transcribe dna =
  match dna with
    |`A -> `U
    |`C -> `G
    |`G -> `C
    |`T -> `A
let to_rna list_dna = filter transcribe list_dna
