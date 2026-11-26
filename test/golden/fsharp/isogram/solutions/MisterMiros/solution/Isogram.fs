module Isogram

let isIsogram (str: string) = 
    let lettersOnly = Seq.filter (System.Char.IsLetter) (str.ToLower())
    set lettersOnly |> Set.count = Seq.length lettersOnly