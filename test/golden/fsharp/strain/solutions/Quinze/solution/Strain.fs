module Seq 

let rec lookFor pred (innerList : List<'a>) (index : int) (goal : bool) =
    if List.length innerList = 0 then innerList
    else if index = List.length innerList then innerList
    else 
        if pred innerList[index] = goal then lookFor pred innerList (index + 1) goal 
        else lookFor pred (List.removeAt index innerList) index goal

let keep pred xs = lookFor pred (List.ofSeq xs) 0 true

let discard pred xs = lookFor pred (List.ofSeq xs) 0 false