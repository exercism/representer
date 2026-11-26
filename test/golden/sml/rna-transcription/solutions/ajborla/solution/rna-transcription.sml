(* ---------------------------------------------------------------------------
   exercism.io
   SML Track Exercise: rna-transcription
   Contributed: Anthony J. Borla (ajborla@bigpond.com)
 -------------------------------------------------------------------------- *)

exception Invalid;

fun toRna (dna : string) : string option =
  let
    fun transcribe (c : char) : char =
      case c of
        #"A" => #"U"
      | #"C" => #"G"
      | #"G" => #"C"
      | #"T" => #"A"
      | _    => raise Invalid
  in
    SOME(String.map transcribe dna)
    handle Invalid => NONE
  end

