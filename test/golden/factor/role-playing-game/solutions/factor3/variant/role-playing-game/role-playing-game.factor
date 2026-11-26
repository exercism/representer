USING: accessors kernel math math.order ;
IN: role-playing-game

TUPLE: player
    name
    { level initial: 0 }
    { health initial: 100 }
    mana ;

: introduce ( player -- string )
    name>> dup "Mighty Magician" ? ;

: revive ( player -- player' )
    [ health>> zero? ] keep 101 >>health 100 >>mana f ? ;

: take-damage ( player damage -- player' )
    '[ _ [-] ] change-health ;
