USING: kernel strings assocs sequences ;
IN: nucleotide-count

ERROR: invalid-nucleotide ;

: nucleotide-counts ( strand -- counts )
    H{ { "A" 0 } { "C" 0 } { "G" 0 } { "T" 0 } } clone
    swap [ dup "ACGT" member? [ 1string over inc-at ] [ invalid-nucleotide throw ] if ] each ;