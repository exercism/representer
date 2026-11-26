(* There doesn't seem to have a built-in exponentiation operator
   for int, "**" is only for float *)
let square_of_sum = function
    | n when n < 1 -> 0
    | n -> let sum = (1 + n) * n / 2
            in sum * sum
let rec sum_of_squares = function
    | n when n < 1 -> 0
    | n -> n * n + sum_of_squares (n - 1)

let difference_of_squares n =
    square_of_sum n + sum_of_squares n
