package protein_translation

proteins :: proc(rna_strand: string) -> ([]string, bool) {
    table :: [?][2]string { {"AUG", "Methionine"}, {"UUU", "Phenylalanine"}, {"UUC", "Phenylalanine"}, {"UUA", "Leucine"}, {"UUG", "Leucine"}, {"UCU", "Serine"}, {"UCC", "Serine"}, {"UCA", "Serine"}, {"UCG", "Serine"}, {"UAU", "Tyrosine"}, {"UAC", "Tyrosine"}, {"UGU", "Cysteine"}, {"UGC", "Cysteine"}, {"UGG", "Tryptophan"}, {"UAA", "STOP"}, {"UAG", "STOP"}, {"UGA", "STOP"} }

    codons : [dynamic]string
    
    for i := 0; i <= len(rna_strand) - 1; i += 3 {
        if i+3 > len(rna_strand) do return nil, false
        amino_acid : string
        for entry in table do if entry[0] == rna_strand[i : i+3] do amino_acid = entry[1]
        if amino_acid == "" do return nil, false; else if amino_acid == "STOP" do break
        append(&codons, amino_acid)
    }
    return codons[:], true
}


