module Darts

let distance (x: double) (y: double): double =
    System.Math.Sqrt( x * x + y * y )

let score (x: double) (y: double): int =
    match (distance x y) with
    | d when d > 10 -> 0
    | d when d > 5 -> 1
    | d when d > 1 -> 5
    | _ -> 10