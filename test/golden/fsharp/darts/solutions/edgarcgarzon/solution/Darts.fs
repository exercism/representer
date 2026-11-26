module Darts

let radius (x:double) (y:double) = 
    sqrt (x ** 2 + y ** 2)

let (|Inner|Middle|Outer|Out|) ((x, y):double*double) =
    match (x,y) with
    | (x, y) when radius x y <= 1. -> Inner
    | (x, y) when radius x y <= 5. -> Middle
    | (x, y) when radius x y <= 10. -> Outer
    | _ -> Out

let score (x: double) (y: double): int = 
    match (x, y) with
    | Inner -> 10
    | Middle -> 5
    | Outer -> 1
    | Out -> 0