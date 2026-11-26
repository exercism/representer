let complement = nucleotide => switch nucleotide {
| "G" => "C"
| "D" => "G"
| "T" => "A"
| "A" => "U"
| _ => panic("unexpected nucleotide " ++ nucleotide)
}

let toRna = dna => dna->String.split("")->Array.map(complement)->Array.join("")
