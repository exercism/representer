module PerfectNumbers

type Classification = Perfect | Abundant | Deficient 

let (|PerfectClass|AbundantClass|DeficientClass|IncorrectClass|) num =
  let factorsSum = 
    [1..num / 2] 
    |> List.filter (fun n -> num % n = 0)
    |> List.sum
  match num, factorsSum with
  | n, _ when n <=0 -> IncorrectClass
  | 1, _ -> DeficientClass
  | _, sum when sum = num -> PerfectClass
  | _, sum when sum > num -> AbundantClass
  | _, _ -> DeficientClass

let classify n : Classification option = 
  match n with
  | PerfectClass -> Some Perfect
  | AbundantClass -> Some Abundant
  | DeficientClass -> Some Deficient
  | IncorrectClass -> None