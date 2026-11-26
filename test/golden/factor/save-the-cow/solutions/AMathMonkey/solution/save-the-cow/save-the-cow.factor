USING: kernel sets math math.order combinators combinators.short-circuit sequences pair-rocket ;
IN: save-the-cow

ERROR: guess-after-ended ;

:: guess ( word guesses -- state masked remaining )
    word fast-set :> letters-left
    9 :> remaining!
    guesses [
        { [ letters-left null? ] [ remaining -1 = ] } 0|| [ guess-after-ended ] when
        letters-left ?delete [ remaining 1 - remaining! ] unless
    ] each 
    {
        [ letters-left null? ] => [ "Win" ]
        [ remaining -1 = ] => [ "Lose" ]
        [ "Ongoing" ]
    } cond
    word [ [ letters-left in? ] [ drop CHAR: _ ] 1when ] map
    remaining 0 max ;
