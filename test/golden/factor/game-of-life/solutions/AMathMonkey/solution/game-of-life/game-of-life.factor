USING: kernel math math.bitwise math.order sequences ranges arrays ;
IN: game-of-life

:: tick ( matrix cols -- matrix' )
    matrix length :> rows
    rows 0 <array> :> matrix'
    rows [0..b) [| i |
      cols [0..b) [| j |
        i matrix nth j bit? :> alive
        i [ ] [ 1 - ] [ 1 + ] tri 3array [
          matrix ?nth [| row |
            j [ ] [ 1 - ] [ 1 + ] tri 3array
            [ row swap bit? ] count
          ] [ 0 ] if*
        ] map-sum
        alive [ 1 - ] when
        [ 3 = ] [ 2 = alive and ] bi or
        [ i matrix' [ j set-bit ] change-nth ] when
      ] each
    ] each
    matrix' ;
