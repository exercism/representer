module Sieve

let primes limit = 
    let removeMultiples x l = 
        l |> List.except [ x .. x .. limit]

    let rec primesImpl primesList remainingList = 
        match remainingList with
        | [] -> primesList
        | x::xs -> primesImpl ([x] |> List.append primesList ) ( removeMultiples x xs )

    primesImpl [] [ 3 .. limit ]


// no mod or div no isPrime