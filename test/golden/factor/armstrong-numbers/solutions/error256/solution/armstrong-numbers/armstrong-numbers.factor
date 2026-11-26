USING: kernel math.functions math.parser sequences ;
IN: armstrong-numbers

: armstrong? ( n -- ? )
    [ >digits dup length '[ _ ^ ] map-sum ] keep = ;
