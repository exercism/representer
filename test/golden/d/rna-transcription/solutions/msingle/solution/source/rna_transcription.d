module rna_transcription;
import std.exception;

string dnaComplement(string dna) {

  char letter(char dna) {
    switch (dna) {
      case 'C':
        return 'G';
      case 'G':
        return 'C';
      case 'T':
        return 'A';
      case 'A':
        return 'U';
      default:
        throw new Exception("not a dna letter!");
    }
  }

  auto switched = "";
  foreach(l; dna) {
    switched ~= letter(l);
  }

  return switched;
}
unittest {
import std.exception : assertThrown;

const int allTestsEnabled = 1;

    assert(dnaComplement("C") == "G");
static if (allTestsEnabled) {
    assert(dnaComplement("G") == "C");
    assert(dnaComplement("T") == "A");
    assert(dnaComplement("A") == "U");

    assert(dnaComplement("ACGTGGTCTTAA") == "UGCACCAGAAUU");

    assertThrown(dnaComplement("U"));
    assertThrown(dnaComplement("XXX"));
    assertThrown(dnaComplement("ACGTXXXCTTAA"));
}

}
