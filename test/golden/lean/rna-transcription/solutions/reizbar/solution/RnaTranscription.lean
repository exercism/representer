namespace RnaTranscription

def toRna (dna : String) : String :=
  dna.map (fun n => match n with
                    | 'G' => 'C'
                    | 'C' => 'G'
                    | 'T' => 'A'
                    | 'A' => 'U'
                    | c => c)

end RnaTranscription
