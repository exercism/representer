USING: assocs hash-sets kernel sequences sets ;
IN: lighthouse-logbook

: empty-log ( -- log )
    HS{ } clone ;

: sight ( log callsign -- )
    swap adjoin ;

: seen? ( log callsign -- ? )
    swap in? ;

: forget-sighting ( log callsign -- )
    swap delete ;

: unique-count ( log -- n )
    cardinality ;

:: reachable ( start relay-map -- visited )
    V{ } clone :> queue
    empty-log :> visited

    start queue push
    start visited adjoin

    [ queue empty? ]
    [
        queue pop
        relay-map at [ visited in? ] reject
        [
            [ queue push ] [ visited adjoin ] bi
        ] each
    ] until

    visited ;
