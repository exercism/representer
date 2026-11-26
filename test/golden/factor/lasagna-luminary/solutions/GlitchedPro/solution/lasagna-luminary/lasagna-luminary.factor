USING: kernel
    math
    combinators
    assocs sequences strings
    locals ;
IN: lasagna-luminary

: cooking-status ( timer -- string )
    {
        { [ dup zero? ] [ drop "Lasagna is done." ] }
        { [ dup not ] [ drop "You forgot to set the timer." ] }
        [ drop "Not done, please wait." ]
    } cond ;

: preparation-time ( layers minutes-per-layer -- total )
    [ length ] dip * ;

:: quantities ( layers -- noodles sauce )
    layers [ "noodles" = ] count 50 * layers [ "sauce" = ] count 1/5 * ;

:: add-secret-ingredient ( friends-list my-list -- new-list )
    friends-list last :> secret 
    my-list secret suffix ;

:: scale-recipe ( recipe portions -- new-recipe )
    recipe [| key value | key value portions * 2 / ] assoc-map ;
