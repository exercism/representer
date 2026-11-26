import java.util.Arrays;
import java.util.List;
import java.util.Map;
class RnaTranscription {


    static final Map<String, String> mapDna = Map.of("G","C",
                                                "C","G", "T", "A", "A","U");

    String transcribe(String dnaStrand) {
        List<String> dnaStrands = Arrays.asList(dnaStrand.split(""));
        String dnaTranscribe = "";
        if(!dnaStrand.isEmpty()) {
            for (String dna : dnaStrands) {
                dnaTranscribe += mapDna.get(dna);
            }
        }
        return dnaTranscribe;
    }

}
