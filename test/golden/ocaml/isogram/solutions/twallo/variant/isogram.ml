module CharSet = Set.Make(Char)

let is_isogram (word: string) : bool =
  let letters =
    word
    |> String.to_seq
    |> Seq.map Char.Ascii.lowercase
    |> Seq.map Char.Ascii.is_letter
    |> List.of_seq in
  CharSet.cardinal (CharSet.of_list letters) = List.length letters

