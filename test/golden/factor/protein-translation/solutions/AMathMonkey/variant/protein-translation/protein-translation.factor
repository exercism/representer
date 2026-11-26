USING: kernel grouping pair-rocket assocs sequences sequences.extras arrays ;
IN: protein-translation

ERROR: invalid-codon ;

CONSTANT: lookup { 
    "AUG" => "Methionine"
    "UUU" => "Phenylalanine"
    "UUC" => "Phenylalanine"
    "UUA" => "Leucine"
    "UUG" => "Leucine"
    "UCU" => "Serine"
    "UCC" => "Serine"
    "UCA" => "Serine"
    "UCG" => "Serine"
    "UAU" => "Tyrosine"
    "UAC" => "Tyrosine"
    "UGU" => "Cysteine"
    "UGC" => "Cysteine"
    "UGG" => "Tryptophan"
    "UAA" => "STOP"
    "UAG" => "STOP"
    "UGA" => "STOP"
}

: proteins ( strand -- result )
    4 group [ lookup at ] map [ "STOP" = not ] take-while
    [ [ not ] any? ] [ invalid-codon ] 1when
    >array ;
