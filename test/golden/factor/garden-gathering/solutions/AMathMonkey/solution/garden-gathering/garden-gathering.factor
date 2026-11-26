USING: kernel math namespaces sequences accessors ;
IN: garden-gathering

TUPLE: plot id registered-to ;

SYMBOLS: registrations next-id not-found ;

: open-garden ( -- )
    V{ } clone registrations set-global
    1 next-id set-global ;

: list-registrations ( -- plots )
    registrations get-global ;

: register ( name -- plot )
    [ next-id get-global ] dip 
    plot boa 
    [ registrations get-global push ] keep 
    next-id [ 1 + ] change-global ;

: release ( id -- )
    registrations get-global
    [ id>> = ] with find
    [ registrations get-global remove-nth! ] when drop ;

: get-registration ( id -- plot/symbol )
    registrations get-global
    [ id>> = ] with find nip
    [ not-found ] unless* ;

: find-by-name ( name -- plots )
    registrations get-global
    [ registered-to>> = ] with filter ;
