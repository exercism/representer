module Isogram

let isIsogram (str: string) = 
  let inc (c: char) (acc: Map<char,int>) =
    match acc.TryFind c with
    | Some _ -> acc.Change(c, fun n -> Some (n.Value + 1))
    | None -> acc.Add(c, 1)
  let rec isogram (acc: Map<char,int>) (chars: char list) =
    match chars with
    | c :: tail when c >= 'a' && c <= 'z' -> isogram (inc c acc) tail
    | _ :: tail -> isogram acc tail
    | [] -> acc
  str.ToLower()
  |> Seq.toList
  |> isogram Map.empty
  |> Map.values
  |> Seq.forall (fun n -> n = 1)