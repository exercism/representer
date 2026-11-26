USING: kernel math sequences regexp math.functions ;
IN: isbn-verifier

: valid-chars ( isbn -- valid-chars/f )
   [ R/ [-\dX]+/ matches? ] 1guard
   [ R/ [\dX]/ all-matching-subseqs concat ] [ f ] if*
   [ [ R/ \d{9}[\dX]/ matches? ] 1guard ] [ f ] if* ;

: valid? ( isbn -- ? )
     valid-chars 
     [ 
       10 swap 
       [ 
         [ CHAR: X = ] [ drop 10 ] [ CHAR: 0 - ] 1if 
         dupd / [ 1 - ] dip
       ] map-sum nip
       11 divisor?
     ] 
     [ f ] 
     if* ;
