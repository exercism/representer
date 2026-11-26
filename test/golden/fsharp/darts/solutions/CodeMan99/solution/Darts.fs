module Darts

let hypotenuse a b = a * a + b * b |> sqrt

let score (x: double) (y: double): int =
    match hypotenuse x y with
    | d when d <= 1.0 -> 10
    | d when d <= 5.0 -> 5
    | d when d <= 10.0 -> 1
    | d -> 0