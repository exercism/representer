USING: kernel sequences sequences.deep ;
IN: flatten-array

: flatten ( array -- flat )
    [ sequence? not ] deep-filter ;
