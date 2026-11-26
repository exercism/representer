namespace ScrabbleScore

def score (word : String) : Int :=
  let score_table := #[1,3,3,2,1,4,2,4,1,8,5,1,3,1,1,3,10,1,1,1,1,4,4,8,4,10]
  word.toLower.toList.map (fun c => score_table[c.toNat - 'a'.toNat]!) |>.sum |> Int.ofNat

end ScrabbleScore
