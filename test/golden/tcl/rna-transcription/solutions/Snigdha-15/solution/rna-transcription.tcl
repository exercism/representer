proc to-rna {dna} {
    set parts [split $dna ""];
    set final ""
    foreach part $parts {
        switch $part {
            "G" {set final_piece "C";}
            "C" {set final_piece "G";}
            "T" {set final_piece "A";}
            "A" {set final_piece "U";}
        }
        append final $final_piece
    }
    return $final
}