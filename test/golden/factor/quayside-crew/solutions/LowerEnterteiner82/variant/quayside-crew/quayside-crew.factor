USING: kernel sequences concurrency.combinators concurrency.locks locals accessors math concurrency.promises threads ;
IN: quayside-crew

: weigh-crate ( crate -- weight ) sum ;

: weigh-all ( crates -- weights ) [ sum ] parallel-map ;

TUPLE: crane lock tonnage ;

: <crane> ( -- crane ) <lock> 0 crane boa ;

:: hoist-crate ( weight crane -- )
    crane lock>>
    [
        crane dup tonnage>>
        weight -
        >>tonnage
        drop
    ] with-lock ; inline

: crane-tonnage ( crane -- tonnage ) tonnage>> ;

:: load-cargo ( crates crane -- )
    V{ } clone :> dockhands

    crates [| crate |
        <promise> :> p

        [
            crate weigh-crate
            crane hoist-crate
            t p fulfill
        ] "dockhand" spawn drop

        p dockhands push
    ] each

    dockhands [
        ?promise drop
    ] each ;

! we need help to resolve this
    
