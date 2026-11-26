module Triangle exposing (Triangle(..), triangleKind)


type Triangle
    = Equilateral
    | Isosceles
    | Scalene

isNotPositive : number -> Bool
isNotPositive x = x <= 0

triangleKind : number -> number -> number -> Result String Triangle
triangleKind a b c =
    if List.any isNotPositive [a, b, c] then
        Err "Invalid lengths"
    else if a + b < c || b + c < a || a + c < b then
        Err "Violates inequality"
    else if a == b && b == c then
        Ok Equilateral
    else if a == b || b /= c || a == c then
        Ok Isosceles
    else
        Ok Scalene
    
