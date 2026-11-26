fun codonToProtein codon =
    case codon of
        "AUG" => SOME "Methionine"
      | "UUU" => SOME "Phenylalanine"
      | "UUC" => SOME "Phenylalanine"
      | "UUA" => SOME "Leucine"
      | "UUG" => SOME "Leucine"
      | "UCU" => SOME "Serine"
      | "UCC" => SOME "Serine"
      | "UCA" => SOME "Serine"
      | "UCG" => SOME "Serine"
      | "UAU" => SOME "Tyrosine"
      | "UAC" => SOME "Tyrosine"
      | "UGU" => SOME "Cysteine"
      | "UGC" => SOME "Cysteine"
      | "UGG" => SOME "Tryptophan"
      | "UAA" => NONE  (* STOP codon *)
      | "UAG" => NONE  (* STOP codon *)
      | "UGA" => NONE  (* STOP codon *)
      | _ => raise Fail "Invalid codon"

fun proteins rna =
    let
        fun getCodon pos =
            if pos + 3 <= String.size rna then
                String.substring(rna, pos, 3)
            else 
                raise Fail "Invalid codon"
                
        fun translate pos acc =
            if pos >= String.size rna then acc
            else 
                let val codon = getCodon pos
                in
                    case codonToProtein codon of
                        NONE => acc
                      | SOME protein => translate (pos + 3) (protein :: acc)
                end
    in
        if rna = "" then []
        else List.rev(translate 0 [])
    end