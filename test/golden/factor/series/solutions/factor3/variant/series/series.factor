USING: combinators grouping kernel math sequences ;
IN: series

: slices ( series length -- slices )
    {
        [ drop empty? [ "series cannot be empty" throw ] when ]
        [ [ length ] dip <= [ "slice length cannot be greater than series length" throw ] when ]
        [ nip zero? [ "slice length cannot be zero" throw ] when ]
        [ nip neg? [ "slice length cannot be negative" throw ] when ]
        [ clump ]
    } 2cleave ;