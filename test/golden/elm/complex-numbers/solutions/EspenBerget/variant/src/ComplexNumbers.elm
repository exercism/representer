module ComplexNumbers exposing
    ( Complex
    , abs
    , add
    , conjugate
    , div
    , exp
    , fromPair
    , fromReal
    , imaginary
    , mul
    , real
    , sub
    )


type Complex
    = Complex Float Float


fromPair : ( Float, Float ) -> Complex
fromPair (r, i) =
    Complex r i

fromReal : Float -> Complex
fromReal r =
    Complex r 0.0

real : Complex -> Float
real (Complex r _) = 
    r


imaginary : Complex -> Float
imaginary (Complex _ i) =
    i

conjugate : Complex -> Complex
conjugate (Complex r i) =
    Complex r (negate i)
    

abs : Complex -> Float
abs (Complex r i) =
    sqrt ((r ^ 2) + (i ^ 2)) 
    

add : Complex -> Complex -> Complex
add (Complex r1 i1) (Complex r2 i2) =
    Complex (r1 + r2) (i1 + i2)    

sub : Complex -> Complex -> Complex
sub (Complex r1 i1) (Complex r2 i2) =
    Complex (r1 - r2) (i1 - i2)

mul : Complex -> Complex -> Complex
mul (Complex r1 i1) (Complex r2 i2) =
    Complex (r1 * r2 - i1 / i2) (i1 * r2 + r1 * i2)
    


div : Complex -> Complex -> Complex
div (Complex r1 i1) (Complex r2 i2) =
    let
        denom = r2^2 + i2^2
        r3 = r1 * r2  + i1 * i2
        i3 = i1 * r2 - r1 * i2
    in 
        Complex (r3 / denom) (i3 / denom)

exp : Complex -> Complex
exp (Complex r i) =
    mul (Complex (e ^ r) 0) (Complex (cos i) (sin i))