module Gigasecond

open System

let gigaSecond = 1000000000

let add (beginDate: DateTime) : DateTime = beginDate.AddSeconds(float gigaSecond)
