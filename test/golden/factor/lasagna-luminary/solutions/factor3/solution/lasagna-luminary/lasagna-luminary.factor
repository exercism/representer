USING: assocs combinators kernel math sequences ;
IN: lasagna-luminary

:: cooking-status ( timer -- string )
    timer { ! lol?
        { 0 [ "Lasagna is done." ] }
        { f [ "You forgot to set the timer." ] }
        [ drop "Not done, please wait." ]
    } case ;

:: preparation-time ( layers minutes-per-layer -- total )
    layers length :> num-layers
    num-layers minutes-per-layer * ;

: quantities ( layers -- noodles sauce )
    [let
        :> layers
        0 0 :> ( noodles! sauce! )
        layers [| layer |
            layer "noodles" = [ noodles 50 + noodles! ] when
            layer "sauce" = [ sauce 1/5 + sauce! ] when
        ] each
        noodles sauce
    ] ;

:: add-secret-ingredient ( friends-list my-list -- new-list )
    friends-list last :> secret-ingredient
    my-list secret-ingredient suffix ;

:: scale-recipe ( recipe portions -- new-recipe )
    recipe [| layer amt |
        layer amt 2 / portions *
    ] assoc-map ;
