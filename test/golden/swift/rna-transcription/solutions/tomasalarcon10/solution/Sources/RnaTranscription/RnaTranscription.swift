func toRna(_ dna: String) -> String {
  // Write your code for the 'Rna Transcription' exercise in this file.
    var complement: [Character:Character] = ["G": "C", "C": "G", "T": "A", "A": "U"]
    return String(dna.map { complement[$0]! })
}