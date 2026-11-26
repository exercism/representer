USING: kernel math ;
IN: eliuds-eggs

: egg-count ( n -- count )
    1 swap
    [ dup 0 = ]
    [ dup 0 bit? [ [ 1 + ] dip ] when 2/ ]
    until drop ;
