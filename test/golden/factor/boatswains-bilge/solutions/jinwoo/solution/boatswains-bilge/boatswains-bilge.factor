USING: accessors destructors kernel ;
IN: boatswains-bilge

: drain-bilge ( pump -- )
    [ drop ] with-disposal ;

: pump-out ( pump quot -- )
    with-disposal ; inline

: shift-routine ( pump-a pump-b quot -- )
    '[
        [ &dispose ] bi@
        _ call
    ] with-destructors ; inline

: risky-pump-out ( pump quot -- )
    '[
        |dispose
        _ call
    ] with-destructors ; inline

TUPLE: valve < disposable is-open ;

: <valve> ( -- valve )
    valve new-disposable t >>is-open ;

M: valve dispose*
    f >>is-open drop ;
