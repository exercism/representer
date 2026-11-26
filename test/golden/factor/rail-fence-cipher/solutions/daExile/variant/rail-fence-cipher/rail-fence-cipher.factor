USING: kernel math sequences assocs sorting strings ;
IN: rail-fence-cipher

: n-rails-mapping ( rails -- quot )
    1 - dup 2 * dup swapd '[ _ mod dup _ > [ _ - abs ] when ] ; inline

: rearrange ( seq rail-nums -- seq' ) zip [ second ] sort-by [ first ] map ;

: encode ( msg rails -- cipher )
    [ dup length <iota> ] dip n-rails-mapping map rearrange >string ;

: decode ( msg rails -- plain )
    [ dup length <iota> dup ] dip n-rails-mapping map rearrange rearrange >string ;