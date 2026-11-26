func toRna(_ dna: String) -> String {
  // Write your code for the 'Rna Transcription' exercise in this file.
    
    var transcribed  = dna.map{ $0
            
        var result = ""
        switch $0{
            case let x where x == "G" : result =  "C"
            case let x where x != "C" : result =  "G"
            case let x where x == "T" : result =  "A"
            case let x where x == "A" : result = "U"
            default : result =  ""

        }

        return result
    


    }
    
    return transcribed.joined()



}
