USING: ascii grouping kernel math math.parser sequences ;
IN: largest-series-product

ERROR: invalid-input ;

: validate-input ( digits span -- )
    2dup [ length ] dip < [ invalid-input ] when
         neg?             [ invalid-input ] when
         [ digit? ] all?  [ invalid-input ] unless ;

: (largest-product) ( digits span -- product )
    [ [ digit> ] { } map-as ] dip clump [ product ] map maximum ;

: largest-product ( digits span -- product )
    2dup validate-input
    [ drop 1 ] [ (largest-product) ] if-zero ;