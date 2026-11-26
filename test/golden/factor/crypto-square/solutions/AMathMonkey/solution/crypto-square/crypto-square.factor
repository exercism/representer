USING: kernel unicode math math.functions grouping splitting sequences sequences.extras ;
IN: crypto-square

: ciphertext ( plaintext -- cipher )
    >lower [ alpha? ] filter
    [ "" ] [
        dup length sqrt ceiling >integer [ group ] keep swap
        [ swap CHAR: space pad-tail ] with [ change-last ] keepd
        flip join-words
    ] if-empty ;
