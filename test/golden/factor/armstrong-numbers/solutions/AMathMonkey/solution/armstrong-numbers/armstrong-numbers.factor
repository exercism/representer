USING: kernel math.functions math.parser sequences ;
IN: armstrong-numbers

: armstrong? ( n -- ? )
    [ >digits [ length ] [ [ swap ^ ] with map-sum ] bi ] keep = ;
