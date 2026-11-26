module PerfectNumbers

type Classification = Perfect | Abundant | Deficient 

let classify n : Classification option =
    if n > 0 then
        let sum =
            { 1..(n - 1) }
                |> Seq.filter (fun x -> n % x = 0)
                |> Seq.sum
        match sum with
            | res when res = n -> Some(Perfect)
            | res when res > n -> Some(Abundant)
            | _ -> Some(Deficient)
    else
        None
