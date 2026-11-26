USING: kernel math math.functions sequences unicode generalizations strings prettyprint io ;
IN: affine-cipher

: encode ( phrase a b -- cipher )
    over 26 gcd nip 1 = [ "a and m must be coprime." throw ] unless
    rot >lower [ [ letter? ] [ digit? ] bi or ] filter
    [
      5 mod 4 = [ " " ] [ "" ] if
      swap [ letter? ] 
      [
        CHAR: a tuck -
        5 npick * 4 npick + 26 mod +
      ] 1when
      1string prepend
    ] { } map-index-as 2nip concat [ blank? ] trim-tail ;

: decode ( phrase a b -- plain )
    [ 26 gcd 1 = [ "a and m must be coprime." throw ] unless ] dip
    rot [ [ letter? ] [ digit? ] bi or ] filter
    [
      [ letter? ] [
        CHAR: a -
        2over rot swap - * 26 rem 
        CHAR: a +
      ] 1when
    ] map 2nip ;
