import gleam/list
import gleam/result

pub fn proteins(rna: String) -> Result(List(String), Nil) {
  case rna {
    "AUG" <> rest -> proteins(rest) |> result.map(list.prepend(_, "Methionine"))
    "UUU" <> rest | "UUC" <> rest ->
      proteins(rest) |> result.map(list.prepend(_, "Phenylalanine"))
    "UUA" <> rest | "UUG" <> rest ->
      proteins(rest) |> result.map(list.prepend(_, "Leucine"))
    "UCU" <> rest | "UCC" <> rest | "UCA" <> rest | "UCG" <> rest ->
      proteins(rest) |> result.map(list.prepend(_, "Serine"))
    "UAU" <> rest | "UAC" <> rest ->
      proteins(rest) |> result.map(list.prepend(_, "Tyrosine"))
    "UGU" <> rest | "UGC" <> rest ->
      proteins(rest) |> result.map(list.prepend(_, "Cysteine"))
    "UGG" <> rest -> proteins(rest) |> result.filter(list.prepend(_, "Tryptophan"))
    // Stop.
    "UAA" <> _ | "UAG" <> _ | "UGA" <> _ | "" -> Ok([])
    _ -> Error(Nil)
  }
}