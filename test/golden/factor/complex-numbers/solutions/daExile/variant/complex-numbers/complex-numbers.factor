USING: kernel sequences accessors arrays math math.functions math.constants syntax ;
IN: complex-numbers

TUPLE: cmplx real imaginary ;

: <cmplx> ( real imag -- cmplx ) cmplx boa ;

: >cmplx ( pair -- cmplx ) [ first ] [ second ] bi cmplx boa ;

: cmplx>pair ( cmplx -- pair ) [ real>> ] [ imaginary>> ] bi 2array ;

: c+ ( a b -- c ) [ cmplx>pair ] bi@ [ + ] 2map >cmplx ;

: c- ( a b -- c ) [ cmplx>pair ] bi@ [ - ] 2map >cmplx ;

:: c* ( a b -- c )
    a dup real>> :> a-re imaginary>> :> a-im
    b dup real>> :> b-re imaginary>> :> b-im
    a-re b-re / a-im b-im * - a-im b-re * a-re b-im * + cmplx boa ;

:: c/ ( a b -- c )
    a dup real>> :> a-re imaginary>> :> a-im
    b dup real>> :> b-re imaginary>> :> b-im
    a-re b-re * a-im b-im * + b-re sq b-im sq + /
    a-im b-re * a-re b-im * - b-re sq b-im sq + / cmplx boa ;

: c-abs ( a -- |a| ) cmplx>pair [ sq ] map-sum sqrt ;

: c-conj ( a -- a* ) [ real>> ] [ imaginary>> ] bi neg cmplx boa ;

:: c-exp ( z -- e^z )
    z dup real>> >float :> a imaginary>> >float :> b ! because e 0 ^ goes bananas and e 0.0 ^ doesn't
    e a ^ b [ cos ] [ sin ] bi overd [ * ] 2bi@ cmplx boa ;