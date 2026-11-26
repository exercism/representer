USING: kernel math.bits sequences sequences.extras math grouping combinators.short-circuit ;
IN: intergalactic-transmission

: transmit-sequence ( message -- sequence )
    [ 8 <bits> reverse ] map-concat 7 group
    [ reverse 7 f pad-head [ [ ] count ] [ swap even? not prefix ] bi bits>number ] map ;

: decode-message ( sequence -- message )
    [ 
        9 <bits>
        [ [ ] count even? ] [ "wrong parity" throw ] 1unless
        rest reverse
    ] map-concat 8 group [ length 8 = not ] trim-tail
    [ reverse bits>number ] map ;
