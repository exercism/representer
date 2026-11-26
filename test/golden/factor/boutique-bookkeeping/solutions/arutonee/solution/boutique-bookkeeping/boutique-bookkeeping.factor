USING: formatting kernel math sequences sorting ;
IN: boutique-bookkeeping

: sort-by-price ( inventory -- sorted )
    [ second ] sort-by ;

: with-missing-price ( inventory -- filtered )
    [ second ] reject ;

: expensive-items ( inventory threshold -- count )
    '[ second _ > ] count ;

: cheapest-item ( inventory -- item )
    [ second ] minimum-by ;

: total-price ( inventory -- sum )
    [ second ] map sum ;

: format-price-tag ( item -- str )
    "%s: $%d" vsprintf ;