USING: ascii combinators.short-circuit kernel sequences splitting
strings ;
IN: acronym

<PRIVATE

: cleanup ( str -- str' )
    [ { [ Letter? ] [ CHAR: space = ] [ CHAR: - = ] } 1|| ] filter ;

PRIVATE>

: abbreviate ( phrase -- acronym )
    cleanup " -" split harvest [ first ch>upper ] map >string ;
