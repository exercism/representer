module Triangle

let equilateral sides =
    match sides with
    | [a; b; c] when a = b && b = c && a > 0.0 -> true
    | _ -> false

let isosceles sides =
    match sides with
    | [a; b; c] when a > 0.0 && b > 0.0 && c > 0.0 ->
        (a = b || b = c || a = c) ||
        (a + b >= c && b + c >= a && a + c >= b)
    | _ -> false

let scalene sides =
    match sides with
    | [a; b; c] when a > 0.0 && b > 0.0 && c > 0.0 ->
        (a <> b && b <> c && a <> c) &&
        (a + b >= c && b + c >= a && a + c >= b)
    | _ -> false
