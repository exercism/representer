func toRna(_ dna: String) -> String {
  // Write your code for the 'Rna Transcription' exercise in this file.
  var rna = ""
    
    for nucleotide in dna {
        switch nucleotide {
        case "G":
            rna += "C"
        case "C":
            rna += "G"
        case "T":
            rna += "A"
        case "A":
            rna += "U"
        default:
            print("Error in transcription")
        }
  }
    
    return rna
  
}
