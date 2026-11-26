module PerfectNumbers

type Classification = Perfect | Abundant | Deficient 

let factors n =
    seq {
        for i = 1 to (n / 2) do
        if n % i = 0 && n <> i then yield i}

let classify n : Classification option =
    match n with
    | x when x <= 0 -> None
    | 1 -> Some Deficient
    | _ -> match factors n |> Seq.sum with
            | x when x = n -> Some Perfect
            | x when n >= x -> Some Deficient
            | x when n < x -> Some Abundant
            | _ -> None