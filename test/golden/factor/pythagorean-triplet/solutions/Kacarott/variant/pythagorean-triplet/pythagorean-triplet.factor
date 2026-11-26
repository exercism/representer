USING: kernel math ranges make sequences ;
IN: pythagorean-triplet

: triplets-with-sum ( n -- triplets )
    [| n |
        n 3 /i [1..b)
        [| a |
            n a - :> d
            a sq d sq + d 2 * /mod
            [| c |
                n a + c - :> b
                a b < [ { a b c } , ] when
            ]
            [ 2drop ]
            if-zero
        ] each 
    ] { } make ;
