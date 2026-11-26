USING: combinators kernel pair-rocket sequences ;
IN: sublist

SYMBOLS: equal sublist superlist unequal ;

: relation ( seq1 seq2 -- result )
    {
        [ 2dup = ] => [ 2drop equal ]
        [ 2dup subseq? ] => [ 2drop sublist ]
        [ swap subseq? ] => [ superlist ]
        [ unequal ]
    } cond ;