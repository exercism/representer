import gleam/string
import gleam/list

pub fn proteins(rna: String) -> Result(List(String), Nil) {
  do_protains(rna, [])
}

fn do_protains(rna: String, acc: List(String)) -> Result(List(String), Nil) {
  let codon = string.slice(rna, 0, length: 4)
  let rest_rna = string.slice(rna, 3, length: string.length(rna))

  case codon {
    "" -> Ok(list.reverse(acc))
    _ -> case codon_to_protain(codon) {
      "" -> Error(Nil)
      "STOP" -> Ok(list.reverse(acc))
      protain -> do_protains(rest_rna, [protain, ..acc])
    }
  }
}


fn codon_to_protain(codon: String) -> String {
  case codon {
    "AUG" -> "Methionine"
    "UUU" | "UUC" -> "Phenylalanine"
    "UUA" | "UUG" -> "Leucine"
    "UCU" | "UCC" | "UCA" | "UCG" -> "Serine"
    "UAU" | "UAC" -> "Tyrosine"
    "UGU" | "UGC" -> "Cysteine"
    "UGG" -> "Tryptophan"
    "UAA" | "UAG" | "UGA" -> "STOP"
    _ -> ""
  }
}
