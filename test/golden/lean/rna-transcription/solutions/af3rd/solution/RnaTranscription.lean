namespace RnaTranscription

def toRna (dna : String) : String :=
  dna.toList.map (λ c =>
  match c with
    | 'A' => "U"
    | 'C' => "G"
    | 'G' => "C"
    | 'T' => "A"
    | _ => "N"
  )
  |> String.join
end RnaTranscription
