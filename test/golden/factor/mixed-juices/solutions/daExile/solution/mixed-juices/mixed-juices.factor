USING: kernel assocs sequences math ;
IN: mixed-juices

CONSTANT: mix-times H{ { "Pure Strawberry Joy" 0.5 } { "Energizer" 1.5 } { "Green Garden" 1.5 } { "Tropical Island" 3 } { "All or Nothing" 5 } }
CONSTANT: lime-yield H{ { "small" 6 } { "medium" 8 } { "large" 10 } }

: time-to-mix-juice ( juice -- minutes ) mix-times at [ 2.5 ] unless* ;

: wedges-from-lime ( size -- wedges ) lime-yield at ;

: limes-to-cut ( needed limes -- count )
    0 -rot
    [ over 0 <= over empty? or ]
    [ unclip wedges-from-lime swapd - swap rot 1 + -rot ] until 2drop ;

: order-times ( orders -- times ) [ time-to-mix-juice ] map ;

: remaining-orders ( time-left orders -- remaining )
    [ over 0 <= over empty? or ] [ unclip time-to-mix-juice swapd - swap ] until nip ;