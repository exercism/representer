USING: ascii grouping kernel math math.functions sequences
sequences.extras ;
IN: crypto-square

: normalize ( str -- newstr )
    [ alpha? ] filter >lower ;

: chunk-size ( str -- n )
    length sqrt ceiling >integer ;

: (chunk) ( seq n -- newseq )
    [ group dup ] keep '[ _ CHAR: space pad-tail ] change-last ;

: chunk ( seq -- newseq )
    dup chunk-size [ drop "" ] [ (chunk) ] if-zero ;

: ciphertext ( plaintext -- cipher )
    normalize chunk flip " " join ;