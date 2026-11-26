type dna = [ `A | `C | `G | `T ]
type rna = [ `A | `C | `G | `U ]

let dna_to_rna = function
| `A -> `U
| `C -> `G
| `G -> `C
| `T -> `A

let to_rna = List.map dna_to_rna
