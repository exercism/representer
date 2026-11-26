class RnaTranscription {
  String toRna(String dna) => dna
      .replaceAll("A", "U")
      .replaceAll("T", "A")
      .replaceAll("G", "-")
      .replaceAll("C", "H")
      .replaceAll("-", "C");
}
