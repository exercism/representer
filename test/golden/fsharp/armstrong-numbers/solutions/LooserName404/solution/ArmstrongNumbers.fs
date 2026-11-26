module ArmstrongNumbers

open System

let isArmstrongNumber (number: int) =
    let digits = number.ToString()
    let len = digits.Length |> float

    let sum =
        digits
        |> Seq.map (fun x -> Double.Parse(x |> string))
        |> Seq.map (fun x -> x ** len)
        |> Seq.sum

    sum = number