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
    Complex r 0


real : Complex -> Float
real (Complex r _) =
    r


imaginary : Complex -> Float
imaginary (Complex _ i) =
    i


conjugate : Complex -> Complex
conjugate (Complex r i) =
    Complex r -i


abs : Complex -> Float
abs (Complex r i) =
    sqrt(r^2 + i^2)


add : Complex -> Complex -> Complex
add (Complex r i) (Complex z j) =
    Complex (r+z) (i+j)


sub : Complex -> Complex -> Complex
sub (Complex r i) (Complex z j) =
    Complex (r-z) (i-j)


mul : Complex -> Complex -> Complex
mul (Complex r i) (Complex z j) = 
    Complex (r * z - i * j) (i * z + r * j)


div : Complex -> Complex -> Complex
div (Complex r i) (Complex z j) = 
    Complex ((r * z + i * j)/(z^2 + j^2)) ((i * z - r * j)/(z^2 - j^2))


exp : Complex -> Complex
exp (Complex r i) =
    Complex (e^r*cos(i)) (e^r*sin(i))
