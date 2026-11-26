class RnaTranscription {

    String transcribe(String dnaStrand) {
        var sb = new StringBuilder(dnaStrand.length());
        for (int i = 0; i < dnaStrand.length(); i++) {
            sb.append(nucleotideToComplement(dnaStrand.charAt(i)));
        }
        return sb.toString();
    }

    private char nucleotideToComplement(char c) {
        return switch (c) {
          case 'G' -> 'C';
          case 'C' -> 'G';
          case 'T' -> 'A';
          case 'A' -> 'U';
          default -> throw new IllegalArgumentException("Not supported: " + c);
        };
    }
}
