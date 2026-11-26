module SumOfMultiples

let sum (numbers: int list) (upperBound: int): int = 
    numbers |> Seq.filter (fun n -> n > 0) |> Seq.collect(fun n -> [n .. n .. upperBound - 1]) |> Seq.distinct |> Seq.sum
    //let newNumbersListsOfList = [
    //    for i in numbers ->
    //        [for j in i .. i .. upperBound-1 -> j] 
    //]
    //let newList = []
    (*for i in newNumbersListsOfList -> newList |> List.append(fun list -> i) |> 
    //newNumbersListsOfList.ToString() |> printfn "%s"
    newNumbersListsOfList |> List.sumBy (fun underList -> underList |> List.sumBy (fun x -> x))*)
    (*numbers.ToString() |> printfn "%s"
    numbers |> List.sumBy (fun x -> if x < upperBound then x else 0)*)
//Switch 2 -> Switch 4 -> Switch 3
//         -> Switch 1  