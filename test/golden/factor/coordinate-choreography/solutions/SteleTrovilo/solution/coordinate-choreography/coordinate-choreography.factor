USING: kernel math.vectors arrays sequences math ;
IN: coordinate-choreography

: translate-2d ( dx dy -- quot )
    ! quote must accept a 2-element sequence like { x y }
    ! harvest x, add dx, harvest y, add dy
    ! '[ [ second ] keep first _ + swap _ + 2array ] ; ! This works, but we can do better
    2array [ v+ ] curry ;

: scale-2d ( sx sy -- quot )
    2array [ v* ] curry ;

: compose-transformations ( f g -- h ) compose ;

: apply-transformation ( point f -- point' )
    call( p -- p' ) ;

: transform-points ( points f -- points' ) map ; inline