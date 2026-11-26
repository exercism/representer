USING: kernel combinators pair-rocket accessors math math.functions namespaces ;
IN: bering-bearings

TUPLE: cardinal direction ;
TUPLE: polar magnitude bearing ;
TUPLE: relative distance bearing ;

SYMBOLS: north east south west
         ahead starboard behind port
         heading ;

GENERIC: >cartesian ( direction -- x y )
GENERIC: flip ( direction -- direction' )

M: cardinal >cartesian
    direction>> {
        north => [ 0 1 ]
        south => [ 0 -1 ]
        east  => [ 1 0 ]
        west  => [ -1 0 ]
    } case ;

M: polar >cartesian
    [ magnitude>> ] [ bearing>> deg>rad ] bi [ sin * ] [ cos * ] 2bi ;

M: relative >cartesian
    [ distance>> ] [ bearing>> {
        ahead     => [ 0 ]
        starboard => [ 90 ]
        behind    => [ 180 ]
        port      => [ 270 ]
    } case heading get - deg>rad ] bi [ sin * ] [ cos * ] 2bi ;

M: cardinal flip
    direction>> {
        north => [ south ]
        south => [ north ]
        east  => [ west ]
        west  => [ east ]
    } case cardinal boa ;

M: polar flip
    [ magnitude>> ] [ bearing>> 180 + 360 rem ] bi polar boa ;

M: relative flip
    [ distance>> ] [ bearing>> ] bi {
        ahead     => [ behind ]
        starboard => [ port ]
        behind    => [ ahead ]
        port      => [ starboard ]
    } case relative boa ;

: add-bearings ( a b -- x y )
    [ >cartesian ] bi@ swapd [ + ] 2bi@ ;
