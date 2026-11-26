USING: kernel math math.order arrays combinators.short-circuit sequences ;
IN: queen-attack

ERROR: row-not-on-board ;
ERROR: column-not-on-board ;

: <queen> ( row column -- queen )
    [ drop 0 8 between? ] [ row-not-on-board ] 2unless 
    [ 0 7 between? ] [ column-not-on-board ] 1unless 
    2array ;

: can-attack? ( queen1 queen2 -- ? )
    { 
      [ [ first ] same? ] 
      [ [ second ] same? ]
      [ [ [ first ] bi@ ] [ [ second ] bi@ ] 2bi [ - abs ] 2bi@ = ]
    } 2|| ;
