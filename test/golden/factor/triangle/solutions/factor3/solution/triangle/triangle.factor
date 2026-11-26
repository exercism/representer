USING: combinators.short-circuit.smart grouping inverse kernel
math sequences sets ;
IN: triangle

: <triangle> ( a b c -- triangle )
    '{ _ _ _ } ;

: triangle? ( triangle -- ? )
    first3 {
        [ + <= ]
        [ spin + <= ]
        [ rot + <= ]
        [ [ 0 0 0 ] matches? not ]
    } && ;

: equilateral? ( triangle -- ? )
    { [ triangle? ] [ all-equal? ] } && ;

: isosceles? ( triangle -- ? )
    { [ triangle? ] [ cardinality 3 < ] } && ;

: scalene? ( triangle -- ? )
    { [ triangle? ] [ cardinality 3 = ] } && ;