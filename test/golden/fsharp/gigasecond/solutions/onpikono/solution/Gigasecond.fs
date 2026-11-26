module Gigasecond

open System

let add (beginDate: DateTime) =
    float 1_000_000_000 |> beginDate.AddSeconds
