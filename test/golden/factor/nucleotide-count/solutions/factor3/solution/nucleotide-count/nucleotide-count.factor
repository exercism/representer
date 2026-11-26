USING: assocs grouping kernel math.statistics regexp ;
IN: nucleotide-count

ERROR: invalid-nucleotide ;

CONSTANT: nucleotides H{ { "A" 0 } { "T" 0 } { "C" 0 } { "G" 0 } }

: nucleotide-counts ( strand -- counts )
    dup R/ [ACGT]*/ matches? [ invalid-nucleotide ] unless
    1 group histogram nucleotides swap assoc-union ;