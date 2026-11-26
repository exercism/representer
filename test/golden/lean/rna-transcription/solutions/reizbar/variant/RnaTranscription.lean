namespace RnaTranscription

def toRna (dna : String) : String :=
  dna.filter (fun n => match n with
                    | 'G' => 'C'
                    | 'C' => 'G'
                    | 'T' => 'A'
                    | 'A' => 'U'
                    | c => c)

end RnaTranscription
