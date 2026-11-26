class RnaTranscription {

    static String toRna(String strand) {
        def transcription
        def result = []
        
        for(String s in strand) {
            transcription = rna(s)
            result << transcription
        }
        result.join()
    }

    static String rna(String s) {
        switch (s) {
            case "G":
                return "C"
            case "C":
                return "G"
            case "U":
                return "A"
            case "A":
                return "U"
            default:
                return ""
        }
    }
}
